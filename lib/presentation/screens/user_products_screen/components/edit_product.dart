import 'package:flutter/material.dart';
import 'package:my_shop/services/providers/auth_provider.dart';
import 'package:my_shop/services/providers/product.dart';
import 'package:my_shop/services/providers/products_provider.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});
  static const String routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _urlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  String string = '';
  final _form = GlobalKey<FormState>();
  late Product _editedProduct;

  bool _isInit = true;
  bool _isLoading = false;

  Map<String, String> _initValue = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _urlFocusNode.addListener(_updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _editedProduct = Product(
      id: null,
      title: '',
      price: 0,
      description: '',
      imageUrl: '',
    );
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String?;
      if (productId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initValue = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': ''
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _urlFocusNode.dispose();
    _urlFocusNode.removeListener(_updateImage);
    super.dispose();
  }

  void _updateImage() {
    if (!_urlFocusNode.hasFocus) {
      String url = _imageUrlController.text;
      bool isWrongStart = !url.startsWith('http') || !url.startsWith('https');
      bool isWrongEnd = !url.endsWith('.png') &&
          !url.endsWith('.jpg') &&
          !url.endsWith('.jpeg');
      if (isWrongStart || isWrongEnd) {
        return;
      }
      string = _imageUrlController.text;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValue['title'],
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: newValue!,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue['price'],
                      decoration: const InputDecoration(
                        labelText: 'Price',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a price';
                        } else if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        } else if (double.parse(value) <= 0) {
                          return 'Please enter number greater than zero';
                        } else {
                          return null;
                        }
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(newValue!),
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue['description'],
                      decoration: const InputDecoration(
                        helperMaxLines: 3,
                        labelText: 'Description',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a description';
                        } else if (value.length < 10) {
                          return 'Need to be at least 10 characters';
                        } else {
                          return null;
                        }
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      onSaved: (newValue) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: newValue!,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: _imageUrlController.text.isEmpty
                              ? const Text('Add URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please provide an image URL';
                              } else if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Enter a valid url';
                              } else if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Enter a valid image url';
                              } else {
                                return null;
                              }
                            },
                            decoration:
                                const InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _urlFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).unfocus();
                            },
                            onEditingComplete: () {
                              setState(() {
                                _saveForm();
                              });
                            },
                            onSaved: (newValue) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: newValue!,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }

  void _closePopUp() {
    Navigator.of(context).pop();
  }

  Future<void> _saveForm() async {
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final ProductsProvider productProvider =
        Provider.of<ProductsProvider>(context, listen: false);

    bool isValid = _form.currentState!.validate();
    if (!isValid) {
      setState(() {});
      return;
    }
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      _editedProduct.userId = authProvider.id;
      await productProvider.updateProduct(
        _editedProduct.id!,
        _editedProduct,
        context,
      );
    } else {
      try {
        _editedProduct.userId = authProvider.id;
        await productProvider.addProduct(_editedProduct, context);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occuured'),
            content: const Text('Something went wrong'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Ok'))
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    _closePopUp();
  }
}
