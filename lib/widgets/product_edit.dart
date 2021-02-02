import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:naylors_client/widgets/widgets.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/blocs/blocs.dart';
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
  ProductList products;
  bool initialized = false;
  bool errorDialogOpen = false;

  @override
  initState() {
    super.initState();
    fields.init();
    initSaveButton();
  }

  @override
  dispose() {
    super.dispose();
    fields.dispose();
    focus.dispose();
    disposeSaveButton();
  }

  initSaveButton() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      this.parent.setState(() {
        BlocProvider.of<NavigatorBloc>(context).floatingButton =
            FloatingActionButton(
          onPressed: saveEdits,
          backgroundColor: Colors.green,
          child: Icon(Icons.save),
        );
      });
    });
  }

  disposeSaveButton() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      this.parent.setState(() {
        BlocProvider.of<NavigatorBloc>(context).floatingButton = null;
      });
    });
  }

  saveEdits() {
    ProductState productState =
        BlocProvider.of<ProductBloc>(parent.context).state;
    this.product = this.fields.product;
    ModifyStep modifyStep;
    if (productState is ProductEditInitial) {
      modifyStep = productState.modifyStep;

      if (modifyStep == ModifyStep.Create) {
        BlocProvider.of<ProductBloc>(parent.context).add(ProductEditEvent(
            tag: initProduct.toString(),
            product: this.product,
            step: modifyStep));
      } else if (modifyStep == ModifyStep.Update) {
        BlocProvider.of<ProductBloc>(parent.context).add(ProductEditEvent(
            tag: initProduct.toString(),
            product: this.product,
            step: modifyStep));
      }
    }

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      this.parent.setState(() {
        BlocProvider.of<NavigatorBloc>(context).floatingButton = null;
      });
    });
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
                          parent.setState(() {});
                          (initProduct != null)
                              ? BlocProvider.of<ProductBloc>(parent.context)
                                  .add(ProductEditEvent(
                                      step: ModifyStep.Initialize,
                                      tag: initProduct.toString()))
                              : BlocProvider.of<ProductBloc>(parent.context)
                                  .add(ProductEditEvent(
                                      step: ModifyStep.Initialize, tag: null));
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.clear),
                        title: Text('Clear'),
                        dense: true,
                        visualDensity: VisualDensity(horizontal: -4),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        onTap: () {
                          this.menuToggle = false;
                          this.overlayEntry.remove();
                          parent.setState(() {
                            this.product = null;
                            this.fields.product = this.product;
                          });
                          BlocProvider.of<ProductBloc>(parent.context).add(
                              ProductEditEvent(
                                  step: ModifyStep.Initialize, tag: null));
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
                          BlocProvider.of<ProductBloc>(context)
                              .add(ProductEditEvent(
                            tag: initProduct.toString(),
                            step: ModifyStep.Delete,
                          ));
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
        BlocProvider.of<ProductListBloc>(context).add(ProductListRequested());
        (initProduct != null)
            ? BlocProvider.of<ProductBloc>(context).add(ProductEditEvent(
                step: ModifyStep.Initialize, tag: initProduct.toString()))
            : BlocProvider.of<ProductBloc>(context)
                .add(ProductEditEvent(step: ModifyStep.Initialize, tag: null));
      }
      if (state is ProductEditInitial) {
        if (state.product != null &&
            this.product == null &&
            initialized == false) {
          SchedulerBinding.instance.addPostFrameCallback((_) => {
                setState(() {
                  product = state.product;
                  fields.product = product;
                  initialized = true;
                })
              });
        } else if (state.product == null && initialized == false) {
          SchedulerBinding.instance.addPostFrameCallback((_) => {
                setState(() {
                  product = null;
                  fields.product = product;
                  initialized = true;
                })
              });
        }
      }
      if (state is ProductEditLoading) {
        loading = true;
      } else
        loading = false;
      if (state is ProductEditSuccess) {
        ModifyStep step = state.step;
        switch (step) {
          case ModifyStep.Initialize:
            // This should never happen.
            break;
          case ModifyStep.Create:
            // TODO: Display box that says 'Creation Successful'
            break;
          case ModifyStep.Update:
            // TODO: Display box that says 'Update Successful'
            break;
          case ModifyStep.Delete:
            // TODO: Display box that says 'Delete Successful'
            // Clear edit page
            break;
        }
      }
      if (state is ProductEditFailure) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            if (!errorDialogOpen) {
              errorDialogOpen = true;
              showDialog(
                context: context,
                useRootNavigator: false,
                builder: (BuildContext context) {
                  return Dialog(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.4,
                      height: MediaQuery.of(context).size.height / 2.8,
                      decoration: new BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: const Color(0xFFFFFF),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(32.0)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 1.4,
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              shape: BoxShape.rectangle,
                              borderRadius: new BorderRadius.vertical(
                                top: Radius.circular(4.0),
                                bottom: Radius.zero,
                              ),
                            ),
                            child: Text("An Error Occurred",
                                textAlign: TextAlign.center,
                                style: style.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Divider(
                            height: 4,
                            color: Colors.lightBlue,
                          ),
                          Expanded(child: Text(state.error)),
                          Divider(
                            height: 4,
                            color: Colors.lightBlue,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                  color: Colors.green,
                                  child: Text("OK",
                                      style:
                                          style.copyWith(color: Colors.white)),
                                  onPressed: () {
                                    initSaveButton();
                                    errorDialogOpen = false;
                                    Navigator.of(context).pop();
                                    BlocProvider.of<ProductBloc>(parent.context).add(
                                        ProductEditEvent(
                                            tag: "$initProduct",
                                            step: ModifyStep.Initialize,
                                            product: product));
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          });
        });
      }
      var productListState = BlocProvider.of<ProductListBloc>(context).state;
      if (productListState is ProductListLoadSuccess) {
        products = productListState.productList;
      }
      return Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(color: Colors.white),
            child: ProductEditBody(
                parent: this,
                products: products,
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
    });
  }
}
