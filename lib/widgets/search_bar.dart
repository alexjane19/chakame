import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/constants.dart';

class PersianSearchBar extends StatefulWidget {
  final String hintText;
  final Function(String) onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onClear;
  final String? initialValue;
  final bool autofocus;
  final TextEditingController? controller;

  const PersianSearchBar({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.initialValue,
    this.autofocus = false,
    this.controller,
  });

  @override
  State<PersianSearchBar> createState() => _PersianSearchBarState();
}

class _PersianSearchBarState extends State<PersianSearchBar>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
      _hasText = widget.initialValue!.isNotEmpty;
    }
    
    _controller.addListener(_onTextChanged);
    
    _animationController = AnimationController(
      duration: AppAnimations.shortDuration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
    widget.onChanged(_controller.text);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _controller,
              textDirection: TextDirection.rtl,
              autofocus: widget.autofocus,
              onSubmitted: widget.onSubmitted,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: theme.primaryColor,
                  size: AppDimensions.iconSizeMedium,
                ),
                suffixIcon: _hasText
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey[600],
                        ),
                        onPressed: () {
                          _controller.clear();
                          widget.onClear?.call();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.cardColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
                  vertical: AppDimensions.paddingMedium,
                ),
              ),
              style: TextStyle(
                fontSize: 16,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ),
        );
      },
    );
  }
}

class SearchSuggestionsList extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onSuggestionTap;
  final bool isLoading;

  const SearchSuggestionsList({
    super.key,
    required this.suggestions,
    required this.onSuggestionTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingLarge),
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Card(
      elevation: AppDimensions.elevationMedium,
      margin: const EdgeInsets.only(top: AppDimensions.marginSmall),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: suggestions.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ListTile(
            leading: Icon(
              Icons.search,
              color: theme.primaryColor,
              size: AppDimensions.iconSizeSmall,
            ),
            title: Text(
              suggestion,
              style: theme.textTheme.bodyMedium,
            ),
            trailing: Icon(
              Icons.arrow_outward,
              color: Colors.grey[600],
              size: AppDimensions.iconSizeSmall,
            ),
            onTap: () => onSuggestionTap(suggestion),
          );
        },
      ),
    );
  }
}

class SearchFilterChips extends StatelessWidget {
  final List<String> filters;
  final String? selectedFilter;
  final Function(String?) onFilterSelected;

  const SearchFilterChips({
    super.key,
    required this.filters,
    this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
        itemCount: filters.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(right: AppDimensions.paddingSmall),
              child: FilterChip(
                selected: selectedFilter == null,
                onSelected: (selected) {
                  onFilterSelected(null);
                },
                label: Text(AppLocalizations.of(context)!.all),
                backgroundColor: Colors.grey[200],
                selectedColor: theme.primaryColor,
                labelStyle: TextStyle(
                  color: selectedFilter == null ? Colors.white : theme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }
          
          final filter = filters[index - 1];
          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.paddingSmall),
            child: FilterChip(
              selected: selectedFilter == filter,
              onSelected: (selected) {
                onFilterSelected(selected ? filter : null);
              },
              label: Text(filter),
              backgroundColor: Colors.grey[200],
              selectedColor: theme.primaryColor,
              labelStyle: TextStyle(
                color: selectedFilter == filter ? Colors.white : theme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }
}