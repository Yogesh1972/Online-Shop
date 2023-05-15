import 'package:flutter/material.dart';
import '../provider/products_provider.dart';

import 'package:provider/provider.dart';
import '../provider/product.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
  static const routeName = '/editProductSscreen';
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _DiscriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageFoucusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  Product editedProduct = Product(
    id: 'NULL',
    ImageUrl: '',
    Name: '',
    description: '',
    price: 00,
  );

  var isit = true;
  var intitValues = {
    // 'id': DateTime.now().toString(),
    'ImageUrl': '',
    'Name': '',
    'description': '',
    'price': '',
  };

  var _IsLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    _imageFoucusNode.addListener(_UpdateImageurl);
    super.initState();
  }

  Future<void> saveForm() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState?.save();
    setState(() {
      _IsLoading = true;
    });

    if (editedProduct.id != 'NULL') {
      await Provider.of<Products>(context, listen: false)
          .UpdateProducts(editedProduct.id, editedProduct);
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(editedProduct);
      } catch (error) {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Something is wrong !!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text('OKay'),
                    )
                  ],
                  content: Text(
                    error.toString(),
                  ),
                ));
      }
      // setState(() {
      //   _IsLoading = false;
      // });
      // Navigator.of(context).pop();
      setState(() {
        _IsLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  void didChangeDependencies() {
    if (isit) {
      final String? Productid =
          ModalRoute.of(context)!.settings.arguments as String?;
      if (Productid != null && Productid != 'NULL') {
        final productdata = Provider.of<Products>(context).findById(Productid);
        editedProduct = productdata;
        intitValues = {
          // 'id': DateTime.now().toString(),
          //'ImageUrl': editedProduct.ImageUrl,
          'Name': editedProduct.Name,
          'description': editedProduct.description,
          'price': editedProduct.price.toString(),
        };
        _imageUrlController.text = editedProduct.ImageUrl;
      }
      isit = false;
      // TODO: implement didChangeDependencies
      super.didChangeDependencies();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _DiscriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    _imageUrlController.dispose();
    _imageFoucusNode.dispose();
    _imageFoucusNode.removeListener(_UpdateImageurl);
    super.dispose();
  }

  void _UpdateImageurl() {
    if (!_imageFoucusNode.hasFocus) {
      if (_imageUrlController.text!.isEmpty &&
          (!_imageUrlController.text.startsWith('https') ||
              !_imageUrlController.text.startsWith('http')) &&
          (!_imageUrlController.text.endsWith('.png') ||
              (!_imageUrlController.text.endsWith('.jpg')) ||
              (!_imageUrlController.text.endsWith('.jpeg')) ||
              (!_imageUrlController.text.endsWith('.jpg')))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: saveForm,
            icon: Icon(
              Icons.save,
            ),
          ),
        ],
      ),
      body: _IsLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: intitValues['Name'],
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter a Title';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        editedProduct = Product(
                          id: editedProduct.id,
                          ImageUrl: editedProduct.ImageUrl,
                          Name: value.toString(),
                          description: editedProduct.description,
                          price: editedProduct.price,
                          Isfavorite: editedProduct.Isfavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: intitValues['price'],
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_DiscriptionFocusNode);
                      },
                      onSaved: (value) {
                        editedProduct = Product(
                          id: editedProduct.id,
                          ImageUrl: editedProduct.ImageUrl,
                          Name: editedProduct.Name,
                          description: editedProduct.description,
                          price: double.parse(value!),
                          Isfavorite: editedProduct.Isfavorite,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter a price';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Enter a number greater than 0';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Enter a valid number';
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                        initialValue: intitValues['description'],
                        decoration: InputDecoration(
                          labelText: 'Discription',
                        ),
                        maxLines: 3,
                        maxLength: 150,
                        keyboardType: TextInputType.multiline,
                        focusNode: _DiscriptionFocusNode,
                        onSaved: (value) {
                          editedProduct = Product(
                            id: editedProduct.id,
                            ImageUrl: editedProduct.ImageUrl,
                            Name: editedProduct.Name,
                            description: value.toString(),
                            price: editedProduct.price,
                            Isfavorite: editedProduct.Isfavorite,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter a Title';
                          }
                          if (value.length < 10) {
                            return 'Discription should be 10 charater long';
                          } else {
                            return null;
                          }
                        }),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            //  initialValue: intitValues['ImageUrl'],
                            decoration: InputDecoration(labelText: 'ImageUrl'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageFoucusNode,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onFieldSubmitted: (_) => saveForm,
                            onSaved: (value) {
                              editedProduct = Product(
                                id: editedProduct.id,
                                ImageUrl: value.toString(),
                                Name: editedProduct.Name,
                                description: editedProduct.description,
                                price: editedProduct.price,
                                Isfavorite: editedProduct.Isfavorite,
                              );
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an image URL.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL.';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid image URL.';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
