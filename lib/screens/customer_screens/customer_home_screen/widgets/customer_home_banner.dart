import 'package:flutter/material.dart';
import 'package:nexprime/constant/app_colors.dart';

class CustomerHomeBanner extends StatefulWidget {
  final List<String> images;
  final double height;

  const CustomerHomeBanner({
    super.key,
    required this.images,
    this.height = 180,
  });

  @override
  State<CustomerHomeBanner> createState() =>
      _CustomerHomeBannerState();
}

class _CustomerHomeBannerState extends State<CustomerHomeBanner> {
  late PageController _controller;
  int _currentPage = 0;
  final int _virtualMultiplier = 1000;

  @override
  void initState() {
    super.initState();
    _controller =
        PageController(initialPage: widget.images.isNotEmpty ? widget.images.length * _virtualMultiplier : 0);
    _currentPage = 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _getRealIndex(int index) => index % widget.images.length;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.images.isEmpty ? 0 : widget.images.length * _virtualMultiplier * 2,
            onPageChanged: (index) {
              setState(() {
                _currentPage = _getRealIndex(index);
              });
            },
            itemBuilder: (context, index) {
              final realIndex = _getRealIndex(index);
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(widget.images[realIndex]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.images.length,
                (index) => _buildDotIndicator(isActive: index == _currentPage),
          ),
        ),
      ],
    );
  }

  Widget _buildDotIndicator({bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: isActive ? AppColors.instance.green : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.instance.green.withAlpha(170),
        ),
      ),
    );
  }
}
