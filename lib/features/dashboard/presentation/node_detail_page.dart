// lib/features/dashboard/presentation/node_detail_page.dart
import 'package:amiflow/features/dashboard/data/node_api.dart';
import 'package:amiflow/features/dashboard/domain/edit_node_result.dart';
import 'package:amiflow/features/dashboard/domain/entities/chart_filter.dart';
import 'package:amiflow/features/dashboard/domain/entities/klasifikasi.dart';
import 'package:amiflow/features/dashboard/domain/entities/usage_history.dart';
import 'package:amiflow/features/dashboard/domain/helpers/history_helper.dart';
import 'package:amiflow/features/dashboard/presentation/widgets/chart_detail_sheet.dart';
import 'package:amiflow/features/dashboard/presentation/widgets/edit_node_bottom_sheet.dart';
import 'package:amiflow/features/schedule/presentation/schedule_page.dart';
import 'package:flutter/material.dart';
import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/dashboard/domain/entities/node.dart';
import 'package:amiflow/features/dashboard/presentation/widgets/usage_chart.dart';
import 'package:amiflow/features/dashboard/presentation/widgets/config_tile.dart';
import 'package:amiflow/features/dashboard/presentation/widgets/remove_node_dialog.dart';
import 'package:amiflow/features/dashboard/data/datasources/history_remote_datasource.dart';
import 'package:amiflow/features/dashboard/data/repositories/history_repository_impl.dart';
import 'package:amiflow/features/dashboard/domain/usecases/get_daily_history.dart';
import 'package:amiflow/features/dashboard/domain/entities/node_detail.dart';
import 'dart:async';

class NodeDetailPage extends StatefulWidget {
  final Node node;
  const NodeDetailPage({super.key, required this.node});

  @override
  State<NodeDetailPage> createState() => _NodeDetailPageState();
}

class _NodeDetailPageState extends State<NodeDetailPage> {
  Timer? _refreshTimer;
  final NodeApi _api = NodeApi(); // tambahkan di atas, sebagai field kelas
  late Node _node;
  NodeDetail? _detail;

  bool _loadingDetail = true;

  String? _detailError;
  late bool _valveOpen;
  late final GetDailyHistory _getDailyHistory;
  List<UsageHistory> _dailyHistory = [];

  // Hasil klasifikasi dari KlasifikasiController. Null selagi belum selesai
  // di-fetch atau kalau fetch gagal -- tampilan tetap sama, cuma fallback
  // diam-diam ke nilai lokal di Node (lihat _buildFlowCard).
  Klasifikasi? _klasifikasi;

  @override
  void initState() {
    super.initState();

    _node = widget.node;
    _valveOpen = _node.valveOpen;

    _loadKlasifikasi();
    _loadNodeDetail();

    Future<void> _loadDailyHistory() async {
      try {
        final data = await _getDailyHistory(_node.id);

        if (!mounted) return;

        setState(() {
          _dailyHistory = data;
        });
      } catch (e) {
        debugPrint('Gagal mengambil histori: $e');
      }
    }

    final datasource = HistoryRemoteDataSource();
    final repository = HistoryRepositoryImpl(datasource);

    _getDailyHistory = GetDailyHistory(repository);
    _loadDailyHistory();

    _refreshTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _loadNodeDetail(),
    );
  }

  //INI NYOBA AJA
  Future<void> _loadKlasifikasi() async {
    try {
      final response = await _api.fetchKlasifikasi(_node.id, 2026, 8);

      if (!mounted) return;

      setState(() {
        _klasifikasi = response;
      });
    } catch (e) {
      debugPrint('Gagal memuat klasifikasi: $e');
    }
  }

  Future<void> _loadNodeDetail() async {
    setState(() {
      _loadingDetail = true;
      _detailError = null;
    });

    try {
      final detail = await _api.fetchNodeDetail(_node.id);
      debugPrint("========== NODE DETAIL ==========");
      debugPrint("Volume : ${detail.telemetry.volume}");
      debugPrint("Flow   : ${detail.telemetry.flow}");
      debugPrint("Valve  : ${detail.telemetry.valveOpen}");

      if (!mounted) return;

      setState(() {
        _detail = detail;
        _valveOpen = detail.telemetry.valveOpen;
        _loadingDetail = false;
      });

      debugPrint("Volume = ${_detail?.telemetry.volume}");
      debugPrint("Flow = ${_detail?.telemetry.flow}");
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _detailError = e.toString();
        _loadingDetail = false;
      });

      debugPrint("Gagal mengambil latest telemetry: $e");
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  double _flowRate = 12.8;

  ChartFilter _selectedFilter = ChartFilter.day;

  /// Total penggunaan sesuai filter
  double get _totalUsage {
    if (_selectedFilter == ChartFilter.year) {
      return dummyTotalUsage[ChartFilter.year]!;
    }

    return HistoryHelper.totalUsage(_currentHistory);
  }

  List<UsageHistory> get _currentHistory {
    switch (_selectedFilter) {
      case ChartFilter.day:
        return _dailyHistory;

      case ChartFilter.week:
        return dummyWeeklyUsage;

      case ChartFilter.month:
        return dummyMonthlyUsage;

      case ChartFilter.year:
        return [];
    }
  }

  /// Data chart sesuai filter
  List<double> get _chartData {
    switch (_selectedFilter) {
      case ChartFilter.day:
        return _currentHistory.map((e) => e.usageLiter).toList();

      case ChartFilter.week:
        return [];

      case ChartFilter.month:
        return [];

      case ChartFilter.year:
        return [];
    }
  }

  /// Label chart sesuai filter
  List<String> get _chartLabels {
    switch (_selectedFilter) {
      case ChartFilter.day:
        return _currentHistory.map((history) => history.dayLabel).toList();

      case ChartFilter.week:
        return [];

      case ChartFilter.month:
        return [];

      case ChartFilter.year:
        return [];
    }
  }

  Future<void> _toggleValve() async {
    if (!_detail!.online) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Valve sedang tidak aktif.\nNode sedang offline sehingga valve tidak dapat dibuka atau ditutup.",
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_detail == null) return;

    final statusBaru = !_valveOpen;

    // ===========================
    // UI langsung berubah
    // ===========================
    setState(() {
      _valveOpen = statusBaru;
    });

    try {
      final hasil = await _api.updateValve(
        deviceId: _detail!.tbDeviceId,
        open: statusBaru,
      );

      if (!mounted) return;

      final bool deviceOffline = hasil['deviceOffline'] == true;
      final bool terkirim = hasil['terkirim'] == true;

      String pesan;
      Color warna;

      if (terkirim && !deviceOffline) {
        // RPC oneway+persistent -- TERKIRIM ke ThingsBoard, tapi device
        // check-in berkala, jadi baru benar-benar diterapkan saat
        // check-in berikutnya (bisa sampai ~15 menit, ini TERBUKTI berhasil).
        pesan = statusBaru
            ? "Perintah buka valve terkirim. Diterapkan saat perangkat check-in berikutnya."
            : "Perintah tutup valve terkirim. Diterapkan saat perangkat check-in berikutnya.";
        warna = Colors.blue;
      } else if (deviceOffline) {
        pesan = "Alat tidak merespons. Perintah TIDAK terkirim.";
        warna = Colors.orange;
        setState(() => _valveOpen = !statusBaru);
      } else {
        pesan = "Gagal mengirim perintah valve.";
        warna = Colors.red;
        setState(() => _valveOpen = !statusBaru);
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(pesan), backgroundColor: warna));

      // TIDAK auto-reload cepat lagi -- kalau ternyata attribute juga
      // butuh sedikit waktu, reload manual (buka ulang halaman) lebih
      // aman daripada auto-reload yang bisa salah menampilkan data lama.
    } catch (e) {
      // ===========================
      // Kalau gagal, balikin UI
      // ===========================
      setState(() {
        _valveOpen = !statusBaru;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal mengubah valve\n$e")));
    }
  }

  Future<void> _deleteNode() async {
    final confirmed = await showRemoveNodeDialog(context, _node.id);
    if (!confirmed) return;
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Future<void> _showEditNodeSheet() async {
    final result = await showModalBottomSheet<EditNodeResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditNodeBottomSheet(node: _node),
    );

    if (result == null) return;

    try {
      final updatedNode = await _api.updateNode(
        id: _node.id,
        namaPemilik: result.owner,
        jumlahPenghuni: result.totalUsers,
      );

      setState(() {
        _node = updatedNode;
        _valveOpen = updatedNode.valveOpen;
      });

      // PENTING: _buildHeader() membaca dari `_detail` (bukan `_node`)
      // untuk nama pemilik & jumlah pengguna. Tanpa baris ini, `_detail`
      // tetap berisi data LAMA sampai halaman dibuka ulang, sehingga
      // header terlihat belum berubah walau `_node` sudah ter-update.
      await _loadNodeDetail();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Node berhasil diperbarui')));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memperbarui node\n$e')));
    }
  }

  void _back() {
    Navigator.pop(context, _node);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildFlowCard(),
              const SizedBox(height: 15),
              _buildUsageHistory(),
              const SizedBox(height: 15),
              _buildValveSection(),
              const SizedBox(height: 30),
              _buildDeleteButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final node = _node;
    final owner = _detail?.owner ?? _node.owner;
    final totalUsers = _detail?.totalUsers ?? _node.totalUsers;
    // baris `final code = ...` boleh dihapus juga karena sudah tidak dipakai

    return Row(
      children: [
        IconButton(
          onPressed: _back,
          icon: const Icon(Icons.arrow_back, color: AppColors.accentSoft),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                'Detail',
                style: const TextStyle(
                  color: AppColors.accentSoft,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Pemilik : $owner',
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
              Text(
                'Pengguna : $totalUsers Orang',
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
              // baris "ID : $code" dihapus
            ],
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 8),
            IconButton(
              tooltip: "Edit Node",
              splashRadius: 22,
              onPressed: _showEditNodeSheet,
              icon: const Icon(Icons.edit_outlined, color: AppColors.accent),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusPill(bool online) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 4,
            backgroundColor: online ? AppColors.online : AppColors.offline,
          ),
          const SizedBox(width: 5),
          Text(
            online ? 'Aktif' : 'NonAktif',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildFlowCard() {
    final node = _node;
    final volume = _detail?.telemetry.volume ?? node.waterUsageM3;

    final valve = _detail?.telemetry.valveOpen ?? node.valveOpen;

    final flow = _detail?.telemetry.flow ?? 0;

    // Sumber data: hasil KlasifikasiController (konsumsi BULANAN resmi,
    // satuan LITER) kalau sudah ada -- INI diprioritaskan, bukan telemetry
    // instan. Sebelumnya urutan fallback terbalik: telemetry.volume
    // (non-nullable) selalu menang duluan, sehingga angka konsumsi bulanan
    // resmi tidak pernah terpakai, dan yang tampil malah pembacaan
    // sesaat meteran (bisa 3 digit desimal & keliru diberi label "m3").
    final String kategori =
        _klasifikasi?.kategori?.toUpperCase() ?? node.usageStatus;

    final bool adaKonsumsiResmi = _klasifikasi?.konsumsiLiter != null;
    final double totalVolumeLiter =
        _klasifikasi?.konsumsiLiter ??
        _detail?.telemetry.volume ??
        node.waterUsageM3;

    Color statusColor;

    switch (kategori) {
      case "HEMAT":
        statusColor = Colors.greenAccent;
        break;

      case "BOROS":
        statusColor = Colors.redAccent;
        break;

      default:
        statusColor = Colors.orangeAccent;
    }

    // Dikonversi ke m3 (1 m3 = 1000 liter), 3 desimal -- contoh: 10 L jadi
    // 0.010 m3, 6 L jadi 0.006 m3. Ditambah padLeft supaya selalu 3 digit
    // di depan koma juga (format "000.000"), contoh: 0.630 -> "000.630".
    final double totalVolumeM3 = totalVolumeLiter / 1000;
    final volumeText = totalVolumeM3.toStringAsFixed(3).padLeft(7, '0');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text(
            "Total Volume Air",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 11,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                volumeText,
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 54,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(width: 6),

              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  "m³",
                  style: TextStyle(color: Colors.white60, fontSize: 18),
                ),
              ),
            ],
          ),

          if (!adaKonsumsiResmi)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                "(pembacaan sesaat, belum konsumsi bulanan resmi)",
                style: TextStyle(color: Colors.white38, fontSize: 10),
              ),
            ),

          const SizedBox(height: 22),

          const SizedBox(height: 24),

          const Text(
            "Flow Rate",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 11,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                flow.toStringAsFixed(2),
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(width: 6),

              const Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  "L/Min",
                  style: TextStyle(color: Colors.white60, fontSize: 16),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Divider(color: Colors.white10, thickness: 1),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const SizedBox(width: 8),

                const Text(
                  "Penggunaan Normal/Bulan",
                  style: TextStyle(color: Colors.white70),
                ),

                const Spacer(),

                Text(
                  "${node.normalUsageM3.toStringAsFixed(1)} m³",
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const SizedBox(width: 8),

                const Text(
                  "Status Bulanan",
                  style: TextStyle(color: Colors.white70),
                ),

                const Spacer(),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 10, color: statusColor),
                      const SizedBox(width: 6),
                      Text(
                        kategori,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageHistory() {
    final hasHistory = _currentHistory.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Riwayat Penggunaan",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          UsageChart(
            selectedFilter: _selectedFilter,
            data: _chartData,
            labels: _chartLabels,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
            onBarTap: (index) {
              if (index >= _currentHistory.length) {
                return;
              }

              final history = _currentHistory[index];

              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) {
                  return ChartBottomSheet(
                    history: history,
                    filter: _selectedFilter,
                    totalUsers: _node.totalUsers,
                    totalUsage: _totalUsage,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildValveSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: _toggleValve,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: _valveOpen
                      ? AppColors.accent
                      : Colors.grey.shade300,
                  child: Icon(
                    _valveOpen ? Icons.lock_open_rounded : Icons.lock_rounded,
                    size: 46,
                    color: _valveOpen ? Colors.black : Colors.black87,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  _valveOpen ? 'Klik Untuk Menutup' : 'Klik Untuk Membuka',
                  style: const TextStyle(color: Colors.white54),
                ),
                const SizedBox(height: 8),
                // const Text(
                //   'Tap To Toggle',
                //   style: TextStyle(color: Colors.white54),
                // ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        const SizedBox(height: 15),

        ConfigTile(
          icon: Icons.event_note,
          title: "Atur Jadwal Valve",
          subtitle: "Konfigurasi otomatis valve",
          onTap: () {
            /// masuk ke halaman schedule
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SchedulePage(nodeId: _node.id)),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDeleteButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.withValues(alpha: 0.2),
          foregroundColor: AppColors.danger,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: _deleteNode,
        icon: const Icon(Icons.delete),
        label: const Text('Hapus Node', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
