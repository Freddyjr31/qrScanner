import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scan/scan_view.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {

  @override
  void initState() {
    super.initState();
    controller.start();
  }

  final MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    torchEnabled: true,
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {

    /// Dimensiones para la ventana de escaneo
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset.zero),
      width: 225,
      height: 225,
    );

    /// almaceno el valor del qr
    dynamic qrValue;
    /// para guardar lo que se escanea e iterar en el
    List<Barcode> barcodes = [];

    return Scaffold(
      backgroundColor: Colors.black12,
      body: Stack(
        fit: StackFit.expand,
        children: [

          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                color: Colors.orange[700],
                backgroundColor: Colors.black87,
              ),
            ),

          Center(
            child: MobileScanner(
              fit: BoxFit.cover,
              controller: controller,
              scanWindow: scanWindow,
              onDetect: (capture) async {

                setState(() {
                  _isLoading = true;
                });

                //* tengo la captura del qr
                barcodes = capture.barcodes;

                //* itero para tener la data
                for (final barcode in barcodes) {
                  qrValue = barcode.rawValue;
                }

                if (qrValue != null) {

                  //* Simula un retraso para mostrar el spinner
                  Future.delayed(const Duration(seconds: 3), () {
                    setState(() {
                      _isLoading = false;
                    });

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      // controller.dispose();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScanView(qrValue: qrValue)
                      ));
                    });
                  });

                  // controller.dispose();
                  //* navego a la visualización del codigo qr
                  // WidgetsBinding.instance.addPostFrameCallback((_) {
                  //   Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => ScanView(qrValue: qrValue)
                  //   ));
                  // });
                }

                barcodes = [];
                // qrValue = [];
                setState(() {});

              },
              //* Imagen que cubre el qr
              overlayBuilder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ScannedBarcodeLabel(barcodes: controller.barcodes),
                  ),
                );
              },
            ),
          ),
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, child) {
              if (!value.isInitialized ||
                  !value.isRunning ||
                  value.error != null) {
                return const SizedBox();
              }
          
              return CustomPaint(
                painter: ScannerOverlay(scanWindow: scanWindow),
              );
            },
          ),
        ],
      ),
    );
  }

  //* DISPOSE
  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }
}


//* OVERLAY
class ScannerOverlay extends CustomPainter {

  const ScannerOverlay({
    required this.scanWindow,
    this.borderRadius = 25.0,
  });

  final Rect scanWindow;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: use `Offset.zero & size` instead of Rect.largest
    // we need to pass the size to the custom paint widget
    final backgroundPath = Path()..addRect(Rect.largest);

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black54 // Make background transparent
      ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 2.0) // Apply blur
      ..style = PaintingStyle.fill // fill
      ..blendMode = BlendMode.srcOver; // dstOut

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 50.0;

    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    // First, draw the background,
    // with a cutout area that is a bit larger than the scan window.
    // Finally, draw the scan window itself.
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow ||
        borderRadius != oldDelegate.borderRadius;
  }
}

//* SCANBAR
class ScannedBarcodeLabel extends StatelessWidget {
  const ScannedBarcodeLabel({
    super.key,
    required this.barcodes,
  });

  final Stream<BarcodeCapture> barcodes;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: barcodes,
      builder: (context, snapshot) {
        final scannedBarcodes = snapshot.data?.barcodes ?? [];

        if (scannedBarcodes.isEmpty) {
          return const Text(
            'Scan something!',
            overflow: TextOverflow.visible,
            style: TextStyle(color: Colors.white),
          );
        }

        return Text(
          scannedBarcodes.first.displayValue ?? 'No display value.',
          overflow: TextOverflow.visible,
          style: const TextStyle(color: Colors.white),
        );
      },
    );
  }
}