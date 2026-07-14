// lib/features/gateway/presentation/gateway_page.dart
import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/gateway/data/gateway_api.dart'; // <-- BARU
import 'package:amiflow/features/gateway/domain/entities/gateway.dart';
import 'package:amiflow/features/gateway/presentation/add_gateway_dialog.dart';
import 'package:amiflow/features/gateway/presentation/widgets/add_gateway.dart';
import 'package:amiflow/features/gateway/presentation/widgets/gateway_banner.dart';
import 'package:amiflow/features/gateway/presentation/widgets/gateway_card.dart';
import 'package:amiflow/features/gateway/presentation/widgets/remove_gateway_dialog.dart';
import 'package:amiflow/features/dashboard/presentation/dashboard_page.dart';
import 'package:amiflow/shared/widgets/amiflow_header.dart';
import 'package:flutter/material.dart';

class GatewayPage extends StatefulWidget {
  const GatewayPage({super.key});

  @override
  State<GatewayPage> createState() => _GatewayPageState();
}

class _GatewayPageState extends State<GatewayPage> {
  final GatewayApi _api = GatewayApi(); // <-- BARU
  List<Gateway> _gateways = []; // mulai kosong
  bool _loading = true; // sedang memuat?
  String? _error; // pesan error (kalau ada)

  @override
  void initState() {
    super.initState();
    _loadGateways(); // <-- ganti: dulu dari dummy, sekarang dari API
  }

  Future<void> _loadGateways() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _api.fetchGateways();
      setState(() {
        _gateways = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat data. Cek koneksi / ngrok.';
        _loading = false;
      });
    }
  }

  Future<void> _onDelete(Gateway gateway) async {
    final confirmed = await showRemoveGatewayDialog(context, gateway.name);
    if (!confirmed) return;

    try {
      await _api.deleteGateway(gateway.id); // hapus di server
      setState(() {
        _gateways.remove(gateway); // baru hapus dari tampilan
      });
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gateway dihapus')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal menghapus gateway')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AmiflowHeader(),

            const GatewayBanner(),

            const SizedBox(height: 20),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Menentukan apa yang ditampilkan: loading / error / grid data
  Widget _buildContent() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadGateways,
              child: const Text("Coba Lagi"),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 50),

      physics: const BouncingScrollPhysics(),

      itemCount: _gateways.length + 1,

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 190,
      ),

      itemBuilder: (context, index) {
        if (index == _gateways.length) {
          return AddGatewayCard(
            onTap: () async {
              final hasil = await showDialog<Map<String, String>>(
                context: context,
                barrierDismissible: true,
                builder: (_) => const AddGatewayDialog(),
              );

              if (hasil == null) return;

              try {
                final baru = await _api.addGateway(
                  kodeGateway: hasil['kode']!,
                  nama: hasil['nama']!,
                );

                setState(() {
                  _gateways.add(baru);
                });

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Gateway ditambahkan")),
                );
              } catch (e) {
                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Gagal menambah gateway")),
                );
              }
            },
          );
        }

        final gateway = _gateways[index];

        return GatewayCard(
          gateway: gateway,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DashboardPage(gateway: gateway),
              ),
            );
          },
          onDelete: () => _onDelete(gateway),
        );
      },
    );
  }
}
