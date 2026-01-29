import 'package:flutter/material.dart';

class SearchableDropdown<T> extends StatefulWidget {
  final List<T> items;
  final String hintText;
  final String Function(T) itemLabel;
  final void Function(T) onChanged;
  final T? selectedItem;
  final expand;

  const SearchableDropdown({
    super.key,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.selectedItem,
    this.hintText = "Select item",
    this.expand,
  });

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  late TextEditingController _searchController;
  late List<T> _sortedItems;
  late List<T> _filteredItems;
  T? _selectedItem;
  int _itemsPerPage = 10;
  int _currentMax = 10;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _sortedItems = List<T>.from(widget.items);
    _sortedItems.sort((a, b) {
      String sa = widget.itemLabel(a).toLowerCase();
      String sb = widget.itemLabel(b).toLowerCase();
      return sa.compareTo(sb);
    });
    _filteredItems = List<T>.from(_sortedItems);
    _selectedItem = widget.selectedItem;
  }

  void _openDropdown(BuildContext context) {
    _searchController.clear();
    _filteredItems = List<T>.from(_sortedItems);
    _currentMax = _itemsPerPage;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: StatefulBuilder(
              builder: (context, setModalState) {
                final ScrollController scrollController = ScrollController();

                scrollController.addListener(() {
                  if (scrollController.position.pixels ==
                      scrollController.position.maxScrollExtent) {
                    if (_currentMax < _filteredItems.length) {
                      setModalState(() {
                        _isLoading = true;
                      });
                      Future.delayed(const Duration(milliseconds: 500), () {
                        setModalState(() {
                          _currentMax = (_currentMax + _itemsPerPage).clamp(
                            0,
                            _filteredItems.length,
                          );
                          _isLoading = false;
                        });
                      });
                    }
                  }
                });

                return Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: "Search...",
                        hintStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        final q = query.toLowerCase();
                        setModalState(() {
                          _filteredItems =
                              _sortedItems.where((item) {
                                return widget
                                    .itemLabel(item)
                                    .toLowerCase()
                                    .contains(q);
                              }).toList();
                          _currentMax = _itemsPerPage;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Stack(
                        children: [
                          ListView.builder(
                            controller: scrollController,
                            itemCount:
                            (_currentMax < _filteredItems.length)
                                ? _currentMax + 1
                                : _filteredItems.length,
                            itemBuilder: (_, index) {
                              if (index == _currentMax &&
                                  _currentMax < _filteredItems.length) {
                                return const SizedBox.shrink();
                              }
                              final item = _filteredItems[index];
                              return ListTile(
                                title: Text(
                                  widget.itemLabel(item),
                                  style: const TextStyle(color: Colors.black),
                                ),
                                onTap: () {
                                  setState(() {
                                    _selectedItem = item;
                                  });
                                  widget.onChanged(item);
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                          if (_isLoading)
                            const Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openDropdown(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _selectedItem != null
                    ? widget.itemLabel(_selectedItem as T)
                    : widget.hintText,
                style: TextStyle(
                  fontSize: 16,
                  color:
                  _selectedItem != null
                      ? Colors.black
                      : Colors.grey.shade600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
