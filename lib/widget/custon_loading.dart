import 'package:busca_gif/ui/home_page.dart';
import 'package:flutter/material.dart';

class CustonLoading extends StatelessWidget {
  const CustonLoading({
    @required this.widget,
    @required this.stroke,
  });

  final HomePage widget;
  final double stroke;

  @override
  build(_) => Center(
        child: CircularProgressIndicator(
          valueColor: widget.color,
          strokeWidth: stroke,
        ),
      );
}
