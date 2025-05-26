import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'country_model.dart';
import 'country_detail_screen.dart';

class CountryListScreen extends StatefulWidget {
  @override
  _CountryListScreenState createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  final List<Country> _allCountries = [];
  final List<Country> _displayedCountries = [];
  int _currentPage = 0;
  final int _itemsPerPage = 10;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchCountries();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _fetchCountries() async {
    if (_isLoading) return;
    
    setState(() => _isLoading = true);
    
    try {
      final response = await http.get(Uri.parse('https://restcountries.com/v3.1/all'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _allCountries.addAll(data.map((json) => Country.fromJson(json)));
        _allCountries.sort((a, b) => a.name.compareTo(b.name));
        _loadMoreData();
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _loadMoreData() {
    final nextPage = _currentPage + 1;
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = nextPage * _itemsPerPage;

    if (startIndex >= _allCountries.length) return;

    setState(() {
      _displayedCountries.addAll(
        _allCountries.sublist(
          startIndex,
          endIndex > _allCountries.length ? _allCountries.length : endIndex,
        ),
      );
      _currentPage = nextPage;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent * 0.9) {
      _loadMoreData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Países do Mundo'),
        centerTitle: true,
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_displayedCountries.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _displayedCountries.length + 1,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemBuilder: (context, index) {
        if (index == _displayedCountries.length) {
          return _buildProgressIndicator(context);
        }
        return _buildCountryCard(context, _displayedCountries[index]);
      },
    );
  }

  Widget _buildCountryCard(BuildContext context, Country country) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToDetail(context, country),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildFlagImage(context, country),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  country.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlagImage(BuildContext context, Country country) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        country.flag,
        width: 80,
        height: 50,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 80,
            height: 50,
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
          width: 80,
          height: 50,
          color: Colors.grey[200],
          child: const Icon(Icons.error_outline),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : const Text('Fim da lista'),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, Country country) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: CountryDetailScreen(country: country),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}