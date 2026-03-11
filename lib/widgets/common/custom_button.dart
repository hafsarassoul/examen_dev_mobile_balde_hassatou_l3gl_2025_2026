import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;     // Affiche un CircularProgressIndicator au lieu du texte
  final bool isOutlined;    // true = OutlinedButton, false = ElevatedButton
  final IconData? icon;     // Icône optionnelle à gauche du texte
  final double? width;
  final double? height;
  final Color? color;

  // Constructeur avec les valeurs par défaut
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.width,
    this.height = 50.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Contenu interne du bouton (Texte ou Indicateur de chargement)
    final Widget labelContent = isLoading
        ? const SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    )
        : Row(
      mainAxisSize: MainAxisSize.min, // C'est ici que l'import material est vital
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),
        ),
      ],
    );

    // 2. Définition du style selon isOutlined
    final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: isOutlined ? Colors.transparent : (color ?? Theme.of(context).primaryColor),
      foregroundColor: isOutlined ? (color ?? Theme.of(context).primaryColor) : Colors.white,
      minimumSize: Size(width ?? double.infinity, height!),
      side: isOutlined
          ? BorderSide(color: color ?? Theme.of(context).primaryColor)
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

    // 3. Retourne le bon type de bouton
    return isOutlined
        ? OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: labelContent,
    )
        : ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: labelContent,
    );
  }
}