import '../providers/madrasah_settings_provider.dart';

class MadrasahTerms {
  static const List<String> qawmiClasses = [
    'Ibtidaiyah (Primary)',
    'Mutawassitah (Middle)',
    'Sanawiyah Ammah (Secondary)',
    'Sanawiyah Khassah (Higher Sec.)',
    'Fazilat (Degree)',
    'Takmil (Masters - Dawra-e-Hadith)',
    'Hifz',
    'Maktab'
  ];

  static const List<String> aliaClasses = [
    'Ibtedayi (Class 1-5)',
    'JDC (Class 6-8)',
    'Dakhil (Class 9-10)',
    'Alim (Class 11-12)',
    'Fazil (Degree)',
    'Kamil (Masters)',
    'Hifz'
  ];

  static List<String> getClasses(MadrasahType type) {
    switch (type) {
      case MadrasahType.qawmi:
        return qawmiClasses;
      case MadrasahType.alia:
        return aliaClasses;
      case MadrasahType.both:
        return {...aliaClasses, ...qawmiClasses}.toList(); 
    }
  }

  static String getInstitutionLabel(MadrasahType type) {
    switch (type) {
      case MadrasahType.qawmi:
        return 'Qawmi Madrasah';
      case MadrasahType.alia:
        return 'Alia Madrasah';
      case MadrasahType.both:
        return 'Madrasah (Combined)';
    }
  }
}

