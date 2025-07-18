import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:paginatedapi/apis/apis.dart';
import 'package:paginatedapi/model/home_model.dart';

class PaginationContainerWidget extends StatefulWidget {
  const PaginationContainerWidget({super.key});

  @override
  State<PaginationContainerWidget> createState() => _PaginationContainerWidgetState();
}

class _PaginationContainerWidgetState extends State<PaginationContainerWidget> {
  static const _pageSize = 20;
  final PagingController<int, Product> _pagingController = PagingController(firstPageKey: 0);
  final ScrollController _scrollController = ScrollController();

  final APIFunction apiFunctions = APIFunction();

  int _scrolledItemCount = 0;
  double itemHeight = 200; // Approximate grid item height
  int _totalItems = 0;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) => _fetchPage(pageKey));
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final result = await apiFunctions.getProducts(page: pageKey);

      setState(() {
        _totalItems = result.totalItems;
      });

      final isLastPage = result.product.length < _pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(result.product);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(result.product, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }


  void _onScroll() {
    // Estimate how many rows are offscreen vertically
    double scrollOffset = _scrollController.offset;
    double rowHeight = itemHeight + 8; // item height + mainAxisSpacing

    int rowsScrolled = scrollOffset ~/ rowHeight;
    int crossAxisCount = 2; // 2 items per row
    int itemsScrolled = rowsScrolled * crossAxisCount;

    setState(() {
      _scrolledItemCount = itemsScrolled;
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text("Scrolled: $_scrolledItemCount / Total: $_totalItems"),
      ),
      body: PagedGridView<int, Product>(
        pagingController: _pagingController,
        scrollController: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: screenWidth / (screenHeight / 1.48),
        ),
        builderDelegate: PagedChildBuilderDelegate<Product>(
          itemBuilder: (context, productItem, index) {
            return Container(
              height: itemHeight,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(productItem.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text("Index: ${index + 1}", style: const TextStyle(color: Colors.grey)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
