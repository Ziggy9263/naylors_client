import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:naylors_client/widgets/widgets.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/util/util.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductEdit extends StatefulWidget {
  final NaylorsHomePageState parent;
  final int initProduct;
  ProductEdit(this.parent, this.initProduct);

  @override
  ProductEditState createState() => ProductEditState(parent, initProduct);
}

class ProductEditState extends State<ProductEdit> {
  final NaylorsHomePageState parent;
  final int initProduct;

  ProductEditState(this.parent, this.initProduct);

  final TextStyle style = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 20.0,
  );
  final _formKey = GlobalKey<FormState>();
  OverlayEntry overlayEntry;
  bool menuToggle = false;
  final LayerLink _layerLink = LayerLink();
  ProductEditFields fields = new ProductEditFields();
  ProductEditFocus focus = new ProductEditFocus();
  ProductDetail product;

  @override
  initState() {
    super.initState();
    fields.init();
  }

  @override
  dispose() {
    super.dispose();
    fields.dispose();
    focus.dispose();
  }

  OverlayEntry createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var offset = renderBox.localToGlobal(Offset.zero);
    return OverlayEntry(
        builder: (context) => Positioned(
              width: 100,
              child: CompositedTransformFollower(
                link: this._layerLink,
                showWhenUnlinked: false,
                offset: Offset(offset.dx - 50, offset.dy - 40),
                child: Material(
                  elevation: 4.0,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.refresh),
                        title: Text('Reload'),
                        dense: true,
                        visualDensity: VisualDensity(horizontal: -4),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        onTap: () {
                          this.menuToggle = false;
                          this.overlayEntry.remove();
                          parent.setState(() {
                            this.product = null;
                          });
                          (initProduct != null)
                              ? BlocProvider.of<ProductBloc>(parent.context)
                                  .add(ProductEditEvent(
                                      step: ModifyStep.Initialize,
                                      tag: initProduct.toString()))
                              : BlocProvider.of<ProductBloc>(parent.context)
                                  .add(ProductEditEvent(
                                      step: ModifyStep.Initialize,
                                      tag: null));
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.visibility),
                        title: Text('View'),
                        dense: true,
                        visualDensity: VisualDensity(horizontal: -4),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        onTap: () {
                          this.menuToggle = false;
                          this.overlayEntry.remove();
                          parent.setState(() {
                            parent.headerTitle = "Naylor's Online: Products";
                          });
                          BlocProvider.of<ProductBloc>(parent.context)
                              .add(ProductReset());
                          BlocProvider.of<NavigatorBloc>(parent.context).add(
                              NavigatorToProduct(
                                  product: int.parse(fields.tag.text)));
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Delete'),
                        dense: true,
                        visualDensity: VisualDensity(horizontal: -4),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        onTap: () {
                          print('Delete');
                          this.menuToggle = false;
                          this.overlayEntry.remove();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
      bool loading = false;
      if (state is ProductInitial) {
        (initProduct != null)
            ? BlocProvider.of<ProductBloc>(context).add(ProductEditEvent(
                step: ModifyStep.Initialize, tag: initProduct.toString()))
            : BlocProvider.of<ProductBloc>(context).add(
                ProductEditEvent(step: ModifyStep.Initialize, tag: null));
      }
      if (state is ProductEditInitial) {
        if (state.product != null && this.product == null) {
          product = state.product;
          fields.product = product;
          SchedulerBinding.instance
              .addPostFrameCallback((_) => {setState(() {})});
        }
        if (state is ProductEditLoading) {
          loading = true;
        } else
          loading = false;
        if (state is ProductEditSuccess) {}
        if (state is ProductEditFailure) {}
        return Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(color: Colors.white),
              child: ProductEditBody(
                  parent: this,
                  fields: fields,
                  formKey: _formKey,
                  focus: focus,
                  style: style,
                  layerLink: _layerLink),
            ),
            AnimatedOpacity(
              opacity: loading ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: loading
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(color: Colors.black54),
                      child: Center(
                          child: CircularProgressIndicator(
                              backgroundColor: Colors.white)))
                  : Container(),
            ),
          ],
        );
      }
      return Center(
          child: CircularProgressIndicator(backgroundColor: Colors.white));
    });
  }
}
