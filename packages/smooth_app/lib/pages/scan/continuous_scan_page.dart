import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:smooth_app/data_models/continuous_scan_model.dart';
import 'package:smooth_app/pages/personalized_ranking_page.dart';
import 'package:smooth_app/pages/scan/scan_page.dart';
import 'package:smooth_app/pages/scan/search_panel.dart';
import 'package:smooth_app/widgets/smooth_product_carousel.dart';
import 'package:smooth_ui_library/smooth_ui_library.dart';

class ContinuousScanPage extends StatelessWidget {
  ContinuousScanPage(this._continuousScanModel);

  final ContinuousScanModel _continuousScanModel;

  final GlobalKey _scannerViewKey = GlobalKey(debugLabel: 'Barcode Scanner');

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ContinuousScanModel>.value(
      value: _continuousScanModel,
      child: Consumer<ContinuousScanModel>(builder: _build),
    );
  }

  Widget _build(
      BuildContext context, ContinuousScanModel model, Widget? child) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0.0),
      body: Stack(
        children: <Widget>[
          ScanPage.getHero(screenSize),
          SmoothRevealAnimation(
            delay: 400,
            startOffset: Offset.zero,
            animationCurve: Curves.easeInOutBack,
            child: QRView(
              key: _scannerViewKey,
              onQRViewCreated: _continuousScanModel.setupScanner,
            ),
          ),
          SmoothRevealAnimation(
            delay: 400,
            startOffset: const Offset(0.0, 0.1),
            animationCurve: Curves.easeInOutBack,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: SmoothViewFinder(
                    width: screenSize.width * 0.8,
                    height: screenSize.width * 0.4,
                    animationDuration: 1500,
                  ),
                )
              ],
            ),
          ),
          SmoothRevealAnimation(
            delay: 400,
            startOffset: const Offset(0.0, -0.1),
            animationCurve: Curves.easeInOutBack,
            child: Column(
              children: <Widget>[
                if (_continuousScanModel.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton.icon(
                        icon: const Icon(Icons.cancel_outlined),
                        onPressed: _continuousScanModel.clearScanSession,
                        label: const Text('Clear'),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.emoji_events_outlined),
                        onPressed: () => _openPersonalizedRankingPage(context),
                        label: Text(localizations.myPersonalizedRanking),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  SmoothProductCarousel(
                    continuousScanModel: _continuousScanModel,
                  )
                ],
              ],
            ),
          ),
          SearchPanel(),
        ],
      ),
    );
  }

  Future<void> _openPersonalizedRankingPage(BuildContext context) async {
    await _continuousScanModel.refreshProductList();
    await Navigator.push<Widget>(
      context,
      MaterialPageRoute<Widget>(
        builder: (BuildContext context) => PersonalizedRankingPage(
          _continuousScanModel.productList,
        ),
      ),
    );
    await _continuousScanModel.refresh();
  }
}
