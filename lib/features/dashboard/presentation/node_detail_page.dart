// lib/features/dashboard/presentation/node_detail_page.dart
import 'package:amiflow/features/dashboard/data/dummy_chart.dart';
import 'package:amiflow/features/dashboard/data/node_api.dart';
import 'package:amiflow/features/dashboard/domain/edit_node_result.dart';
import 'package:amiflow/features/dashboard/domain/entities/chart_filter.dart';
import 'package:amiflow/features/dashboard/domain/entities/klasifikasi.dart';
import 'package:amiflow/features/dashboard/presentation/widgets/chart_detail_sheet.dart';
import 'package:amiflow/features/dashboard/presentation/widgets/edit_node_bottom_sheet.dart';
import 'package:amiflow/features/schedule/presentation/schedule_page.dart';
import 'package:flutter/material.dart';
import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/dashboard/domain/entities/node.dart';
import 'package:amiflow/features/dashboard/presentation/widgets/usage_chart.dart';
import 'package:amiflow/features/dashboard/presentation/widgets/stat_card.dart';
import 'package:amiflow/features/dashboard/presentation/widgets/config_tile.dart';
import 'package:amiflow/features/dashboard/presentation/widgets/remove_node_dialog.dart';

class NodeDetailPage extends StatefulWidget {
  final Node node;
  const NodeDetailPage({super.key, required this.node});

  @override
  State<NodeDetailPage> createState() => _NodeDetailPageState();
}

class _NodeDetailPageState extends State<NodeDetailPage> {
  final NodeApi _api = NodeApi(); // tambahkan di atas, sebagai field kelas
  late Node _node;
  late bool _valveOpen;

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
  }
  //IN YANG BENER
  // Default: bulan berjalan. Ganti di sini kalau nanti ada filter periode.
  // Future<void> _loadKlasifikasi() async {
  //   final now = DateTime.now();
  //   try {
  //     final hasil = await _api.fetchKlasifikasi(widget.node.id, now.year, now.month);
  //     if (!mounted) return;
  //     setState(() {
  //       _klasifikasi = hasil;
  //     });
  //   } catch (e) {
  //     // Diamkan -- tampilan tetap pakai fallback lokal, tidak mengubah UI.
  //     debugPrint('Gagal memuat klasifikasi: $e');
  //   }
  // }

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

  double _flowRate = 12.8;
  ChartFilter _selectedFilter = ChartFilter.day;

  double get _totalUsage {
    return _chartData.fold(0.0, (total, value) => total + value);
  }

  List<double> get _chartData {
    return dummyChartData[_selectedFilter] ?? [];
  }

  Future<void> _toggleValve() async {
    final statusBaru = !_valveOpen;

    // ubah tampilan dulu (biar responsif)
    setState(() {
      _valveOpen = statusBaru;
    });

    try {
      final hasilServer = await _api.updateValve(_node.id, statusBaru);
      // sinkronkan dengan status yang dikonfirmasi server
      setState(() {
        _valveOpen = hasilServer;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(hasilServer ? 'Valve dibuka' : 'Valve ditutup')),
      );
    } catch (e) {
      // kalau gagal, kembalikan tampilan ke status semula
      setState(() {
        _valveOpen = !statusBaru;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal mengubah valve')));
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
    return Row(
      children: [
        IconButton(
  onPressed: _back,
  icon: const Icon(
    Icons.arrow_back,
    color: AppColors.accentSoft,
  ),
),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                '${node.id} Detail',
                style: const TextStyle(
                  color: AppColors.accentSoft,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Pemilik : ${node.owner}',
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
              Text(
                'Pengguna : ${node.totalUsers} Orang',
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
              Text(
                'ID : ${node.code}',
                style: const TextStyle(color: AppColors.accent, fontSize: 12),
              ),
            ],
          ),
        ),
        Row(
          children: [
            // _buildStatusPill(node.online),
            const SizedBox(width: 8),
            IconButton(
              tooltip: "Edit Node",
              splashRadius: 22,
              onPressed: () {
                print("Edit diklik");
                _showEditNodeSheet();
              },
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

    // Sumber data: hasil KlasifikasiController kalau sudah ada,
    // fallback ke nilai lokal Node selagi belum selesai fetch / fetch gagal.
    // Tampilan (layout, label, warna) tetap sama seperti sebelumnya.
    final String kategori =
        _klasifikasi?.kategori?.toUpperCase() ?? node.usageStatus;
    final double totalVolume = _klasifikasi?.konsumsiM3 ?? node.waterUsageM3;

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

          Text(
            totalVolume.toStringAsFixed(2),
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 54,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Text(
            "m³",
            style: TextStyle(color: Colors.white60, fontSize: 16),
          ),

          const SizedBox(height: 22),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.water_drop_outlined,
                  color: AppColors.accent,
                  size: 18,
                ),

                const SizedBox(width: 8),

                const Text(
                  "Penggunaan Normal Perbulan",
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(.12),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 12, color: statusColor),

                const SizedBox(width: 8),

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
    );
  }

  Widget _buildUsageHistory() {
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
              'Riwayat Penggunaan',
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
            labels: dummyChartLabels[_selectedFilter]!,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },

            onBarTap: (index) {
              showModalBottomSheet(
                context: context,

                backgroundColor: Colors.transparent,

                isScrollControlled: true,

                builder: (_) {
                  return ChartBottomSheet(
                    title: dummyChartLabels[_selectedFilter]![index],

                    usage: _chartData[index],

                    totalUsage: _totalUsage,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 20),

          StatCard(
            title: "Total Penggunaan",
            value: "${_totalUsage.toStringAsFixed(2)} m³",
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
