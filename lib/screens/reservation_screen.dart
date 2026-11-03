
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/destination.dart';
import '../models/reservation.dart';

class ReservationScreen extends StatefulWidget {
  final Destination destination;
  final int voyageurs;

  const ReservationScreen({
    super.key,
    required this.destination,
    required this.voyageurs,
  });

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();

  DateTime? _date;
  String _formule = 'Essentiel';
  bool _conditions = false;
  AutovalidateMode _autoValidation = AutovalidateMode.disabled;

  int get _prixParPersonne => _formule == 'Confort'
      ? (widget.destination.prix * 1.3).round()
      : widget.destination.prix;

  int get _total => _prixParPersonne * widget.voyageurs;

  @override
  void dispose() {
    _nomCtrl.dispose();
    _emailCtrl.dispose();
    _telCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  InputDecoration _deco(String label, IconData icone, {String? aide}) {
    return InputDecoration(
      labelText: label,
      helperText: aide,
      prefixIcon: Icon(icone),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  String? _validatorNom(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Indiquez votre nom';
    }
    if (v.trim().length < 3) {
      return 'Au moins 3 caractères';
    }
    return null;
  }

  String? _validatorEmail(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Indiquez votre e-mail';
    }

    final regex = RegExp(r'^[\w.+]+@[\w-]+\.[\w.]+$');

    if (!regex.hasMatch(v.trim())) {
      return 'E-mail invalide (ex. : nom@mail.tn)';
    }

    return null;
  }

  String? _validatorTel(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Indiquez votre téléphone';
    }

    if (!RegExp(r'^\d{8}$').hasMatch(v.trim())) {
      return '8 chiffres attendus';
    }

    return null;
  }

  // Choisir la date de départ
  Future<void> _choisirDate() async {
    final maintenant = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: _date ?? maintenant,
      firstDate: maintenant,
      lastDate: DateTime(maintenant.year + 2),
    );

    if (date != null) {
      setState(() {
        _date = date;
        _dateCtrl.text =
            '${date.day.toString().padLeft(2, '0')}/'
            '${date.month.toString().padLeft(2, '0')}/'
            '${date.year}';
      });
    }
  }

  // Valider le formulaire
  void _valider() {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _autoValidation = AutovalidateMode.onUserInteraction;
      });
      return;
    }

    if (_date == null) {
      setState(() {
        _autoValidation = AutovalidateMode.onUserInteraction;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Choisissez une date de départ'),
        ),
      );
      return;
    }

    if (!_conditions) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Formulaire valide'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final d = widget.destination;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Réserver'),
      ),

      body: Form(
        key: _formKey,
        autovalidateMode: _autoValidation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Récapitulatif
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      d.image,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d.nom,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${d.duree} • ${widget.voyageurs} voyageur(s)',
                          style: TextStyle(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text(
                'Informations personnelles',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // Nom complet
              TextFormField(
                controller: _nomCtrl,
                decoration: _deco(
                  'Nom complet',
                  Icons.person_outline,
                ),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: _validatorNom,
              ),

              const SizedBox(height: 16),

              // E-mail
              TextFormField(
                controller: _emailCtrl,
                decoration: _deco(
                  'E-mail',
                  Icons.email_outlined,
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: _validatorEmail,
              ),

              const SizedBox(height: 16),

              // Téléphone
              TextFormField(
                controller: _telCtrl,
                decoration: _deco(
                  'Téléphone',
                  Icons.phone_outlined,
                  aide: '8 chiffres, sans indicatif',
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8),
                ],
                validator: _validatorTel,
              ),

              const SizedBox(height: 24),

              // Votre voyage
              Text(
                'Votre voyage',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // Date de départ
              TextFormField(
                controller: _dateCtrl,
                readOnly: true,
                onTap: _choisirDate,
                decoration: _deco(
                  'Date de départ',
                  Icons.calendar_month_outlined,
                ),
                validator: (_) =>
                    _date == null ? 'Choisissez une date' : null,
              ),

              const SizedBox(height: 16),

              // Formule
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'Essentiel',
                    label: Text('Essentiel'),
                    icon: Icon(Icons.backpack_outlined),
                  ),
                  ButtonSegment(
                    value: 'Confort',
                    label: Text('Confort +30 %'),
                    icon: Icon(Icons.hotel_outlined),
                  ),
                ],
                selected: {_formule},
                onSelectionChanged: (choix) {
                  setState(() {
                    _formule = choix.first;
                  });
                },
              ),

              const SizedBox(height: 8),

              // Conditions
              CheckboxListTile(
                value: _conditions,
                onChanged: (v) {
                  setState(() {
                    _conditions = v ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "J'accepte les conditions d'annulation",
                ),
                subtitle: const Text(
                  'Annulation gratuite jusqu\'à 48 h avant',
                ),
              ),
            ],
          ),
        ),
      ),

      // Barre du bas : prix et confirmation
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '$_prixParPersonne DT × ${widget.voyageurs}',
                  style: TextStyle(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),

              Text(
                '$_total DT',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _conditions ? _valider : null,
                  icon: const Icon(Icons.check),
                  label: const Text('Confirmer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
