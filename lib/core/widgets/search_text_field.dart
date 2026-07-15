import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/product/presentation/cubit/products_list/products_cubit.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({
    super.key,
    this.hintText = 'Search',
    this.debounceDuration = const Duration(milliseconds: 400),
  });

  final String hintText;
  final Duration debounceDuration;

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      context.read<ProductsCubit>().filterProducts(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onChanged,
      decoration: InputDecoration(
        labelText: widget.hintText,
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  _onChanged('');
                  setState(() {});
                },
              ),
      ),
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
    );
  }
}
