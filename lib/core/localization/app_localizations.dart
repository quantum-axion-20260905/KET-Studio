enum AppLanguage { english, uzbek }

class AppStrings {
  final AppLanguage language;

  const AppStrings(this.language);

  static AppStrings forLanguage(AppLanguage language) => AppStrings(language);

  bool get isUzbek => language == AppLanguage.uzbek;

  String get(String key) {
    final value = (isUzbek ? _uzbek : _english)[key];
    return value ?? key;
  }

  String duration(String value) {
    if (!isUzbek) return value;
    return value.replaceAll('min', 'daq');
  }

  String difficulty(String value) {
    if (!isUzbek) return value;
    switch (value) {
      case 'beginner':
        return 'boshlang‘ich';
      case 'intermediate':
        return 'o‘rta';
      case 'advanced':
        return 'yuqori';
      default:
        return value;
    }
  }

  static const _english = <String, String>{
    'settings': 'Settings',
    'copyJson': 'Copy JSON',
    'close': 'Close',
    'configuration': 'CONFIGURATION',
    'configurationHint': 'KET Studio desktop configuration',
    'appearance': 'Appearance',
    'appearanceHint': 'Theme, language, density, and desktop shell.',
    'editor': 'Editor',
    'editorHint': 'Code editing, readability, and save workflow.',
    'terminal': 'Terminal',
    'terminalHint': 'Runtime output, retention, and execution logging.',
    'environment': 'Environment',
    'environmentHint': 'Interpreter, packages, and runtime health.',
    'advanced': 'Advanced',
    'advancedHint': 'Diagnostics, export, and recovery actions.',
    'language': 'Language',
    'languageHint': 'Choose the language used by the KET Studio interface.',
    'english': 'English',
    'uzbek': 'O‘zbekcha',
    'themeMode': 'Theme mode',
    'themeModeHint': 'Switch between light and dark desktop themes.',
    'dark': 'Dark',
    'light': 'Light',
    'accentColor': 'Accent color',
    'accentColorHint':
        'Used across active panels, buttons, and emphasis states.',
    'compactDensity': 'Compact density',
    'compactDensityHint':
        'Use tighter spacing across menus, bars, and controls.',
    'startMaximized': 'Start maximized',
    'startMaximizedHint': 'Open the desktop shell maximized on startup.',
    'editorFontSize': 'Editor font size',
    'editorFontSizeHint': 'Controls the main code editor text size.',
    'editorLineHeight': 'Editor line height',
    'editorLineHeightHint':
        'Increase vertical spacing for denser or airier code.',
    'wordWrap': 'Word wrap',
    'wordWrapHint': 'Wrap long lines inside the editor viewport.',
    'autoSave': 'Auto save',
    'autoSaveHint': 'Persist real files automatically after edits settle.',
    'terminalFontSize': 'Terminal font size',
    'terminalFontSizeHint':
        'Controls terminal output and stdin input text size.',
    'terminalMaxLines': 'Maximum retained terminal lines',
    'terminalMaxLinesHint':
        'Older lines are trimmed once this limit is reached.',
    'autoScroll': 'Auto scroll terminal',
    'autoScrollHint': 'Keep the terminal pinned to the latest output.',
    'clearTerminal': 'Clear terminal on run',
    'clearTerminalHint':
        'Clear previous output before starting a new execution.',
    'executionDetails': 'Show execution details',
    'executionDetailsHint':
        'Print interpreter, project, and entrypoint metadata.',
    'pythonInterpreter': 'Python interpreter',
    'pythonInterpreterHint':
        'This path is used for script execution and package management.',
    'browse': 'Browse',
    'reset': 'Reset',
    'environmentStatus': 'Environment status',
    'ready': 'Ready',
    'notReady': 'Not ready',
    'provisioning': 'Provisioning',
    'idle': 'Idle',
    'rebuildEnvironment': 'Rebuild environment',
    'copyConfig': 'Copy config',
    'configurationPreview': 'Configuration preview',
    'resetSettings': 'Reset settings',
    'resetSettingsHint':
        'Restore all persisted settings to their default values.',
    'resetDefaults': 'Reset defaults',
    'runtimeSnapshot': 'Runtime snapshot',
    'platform': 'Platform',
    'interpreter': 'Interpreter',
    'environmentReady': 'Environment ready',
    'learningLab': 'LEARNING LAB',
    'masterQuantum': 'Master quantum computation',
    'learningSubtitle':
        'Guided lessons with runnable experiments and visual feedback.',
    'back': 'Back',
    'openInEditor': 'Open in editor',
    'tryTemplate': 'Try template',
    'runTemplate': 'Run template',
    'templateUnavailable': 'This lesson has no runnable template yet.',
    'lesson': 'lesson',
    'lessons': 'lessons',
    'steps': 'steps',
    'visualOutput': 'Visual output',
    'visualOutputHint':
        'Run the template to send charts, metrics, and histograms to the workspace.',
    'tutorialLibrary': 'Tutorial library',
    'tutorialLibraryHint': 'Choose a path, then run the included experiment.',
    'tutorialPanelTitle': 'TUTORIALS',
    'tutorialPanelTooltip': 'Quantum education and tutorials',
    'stop': 'Stop',
    'run': 'Run',
    'running': 'Running',
    'workspaceReady': 'Quantum workspace ready',
    'envReady': 'Env ready',
    'envLoading': 'Env loading',
    'pythonRunning': 'Python running',
    'engineIdle': 'Engine idle',
    'controlCenter': 'KET STUDIO / CONTROL CENTER',
    'workspaceTitle': 'Quantum analysis workspace',
    'workspaceSubtitle':
        'Write Python experiments, run them locally, and inspect structured quantum results in one desktop workspace.',
    'scripts': 'Scripts',
    'scriptsHint': 'Python and quantum workflows',
    'panels': 'Panels',
    'panelsHint': 'Inspector, metrics and history',
    'execution': 'Execution',
    'executionHint': 'Run locally and inspect output',
    'actions': 'ACTIONS',
    'newFile': 'New file',
    'newFileHint': 'Start a fresh experiment or utility script.',
    'openFolder': 'Open folder',
    'openFolderHint': 'Load an existing workspace from disk.',
    'tryDemo': 'Try demo',
    'tryDemoHint': 'Open a prepared visualization sample.',
    'workspace': 'WORKSPACE',
    'projectState': 'Project state',
    'projectStateHint': 'No recent items yet. Create your first workspace.',
    'visualization': 'Visualization',
    'visualizationHint':
        'Run a script and inspect inspector, charts, and history.',
    'environmentHintWelcome':
        'Manage the Python path and packages from inside the IDE.',
    'quantumTemplates': 'QUANTUM TEMPLATES',
    'quantumTemplatesHint':
        'Start from curated examples instead of an empty editor.',
    'learningResources': 'Learning Resources',
    'quantumHardware': 'Quantum Hardware',
  };

  static const _uzbek = <String, String>{
    'settings': 'Sozlamalar',
    'copyJson': 'JSON nusxalash',
    'close': 'Yopish',
    'configuration': 'SOZLAMALAR',
    'configurationHint': 'KET Studio desktop konfiguratsiyasi',
    'appearance': 'Ko‘rinish',
    'appearanceHint': 'Mavzu, til, zichlik va desktop qobig‘i.',
    'editor': 'Editor',
    'editorHint': 'Kod yozish, o‘qilish va saqlash jarayoni.',
    'terminal': 'Terminal',
    'terminalHint': 'Natija, saqlash limiti va ishga tushirish jurnali.',
    'environment': 'Muhit',
    'environmentHint': 'Interpreter, paketlar va runtime holati.',
    'advanced': 'Kengaytirilgan',
    'advancedHint': 'Diagnostika, eksport va tiklash amallari.',
    'language': 'Til',
    'languageHint': 'KET Studio interfeysi ishlatadigan tilni tanlang.',
    'english': 'English',
    'uzbek': 'O‘zbekcha',
    'themeMode': 'Mavzu rejimi',
    'themeModeHint': 'Yorug‘ yoki qorong‘i desktop mavzusini tanlang.',
    'dark': 'Qorong‘i',
    'light': 'Yorug‘',
    'accentColor': 'Ajratish rangi',
    'accentColorHint':
        'Faol panellar, tugmalar va urg‘u holatlarida ishlatiladi.',
    'compactDensity': 'Ixcham zichlik',
    'compactDensityHint':
        'Menyu, panellar va boshqaruvlarda zichroq oraliq ishlatadi.',
    'startMaximized': 'Katta oynada boshlash',
    'startMaximizedHint':
        'Desktop qobig‘ini ishga tushganda maksimal holatda ochadi.',
    'editorFontSize': 'Editor shrift o‘lchami',
    'editorFontSizeHint': 'Asosiy kod editoridagi matn o‘lchamini boshqaradi.',
    'editorLineHeight': 'Editor qator balandligi',
    'editorLineHeightHint':
        'Kod qatorlari orasini zichroq yoki kengroq qiladi.',
    'wordWrap': 'Qatorni avtomatik o‘rash',
    'wordWrapHint': 'Uzun qatorlarni editor oynasida keyingi qatorga o‘raydi.',
    'autoSave': 'Avtomatik saqlash',
    'autoSaveHint': 'Tahrirdan keyin haqiqiy fayllarni avtomatik saqlaydi.',
    'terminalFontSize': 'Terminal shrift o‘lchami',
    'terminalFontSizeHint':
        'Terminal natijasi va stdin matni o‘lchamini boshqaradi.',
    'terminalMaxLines': 'Terminalda saqlanadigan qatorlar',
    'terminalMaxLinesHint': 'Limitga yetganda eski qatorlar olib tashlanadi.',
    'autoScroll': 'Terminalni avtomatik aylantirish',
    'autoScrollHint': 'Terminalni eng so‘nggi natijaga biriktirib turadi.',
    'clearTerminal': 'Ishga tushirganda terminalni tozalash',
    'clearTerminalHint':
        'Yangi ishga tushirishdan oldin eski natijani tozalaydi.',
    'executionDetails': 'Ishga tushirish ma’lumotlarini ko‘rsatish',
    'executionDetailsHint':
        'Interpreter, loyiha va entrypoint ma’lumotlarini chiqaradi.',
    'pythonInterpreter': 'Python interpreteri',
    'pythonInterpreterHint':
        'Bu manzil skript ishga tushirish va paket boshqaruvida ishlatiladi.',
    'browse': 'Tanlash',
    'reset': 'Tiklash',
    'environmentStatus': 'Muhit holati',
    'ready': 'Tayyor',
    'notReady': 'Tayyor emas',
    'provisioning': 'Tayyorlanmoqda',
    'idle': 'Bo‘sh',
    'rebuildEnvironment': 'Muhitni qayta tayyorlash',
    'copyConfig': 'Konfiguratsiyani nusxalash',
    'configurationPreview': 'Konfiguratsiya ko‘rinishi',
    'resetSettings': 'Sozlamalarni tiklash',
    'resetSettingsHint':
        'Saqlangan barcha sozlamalarni standart holatiga qaytaradi.',
    'resetDefaults': 'Standartga qaytarish',
    'runtimeSnapshot': 'Runtime snapshot',
    'platform': 'Platforma',
    'interpreter': 'Interpreter',
    'environmentReady': 'Muhit tayyor',
    'learningLab': 'O‘RGANISH LABORATORIYASI',
    'masterQuantum': 'Kvant hisoblashni o‘rganing',
    'learningSubtitle':
        'Yo‘naltirilgan darslar, ishga tushadigan tajribalar va vizual natijalar.',
    'back': 'Orqaga',
    'openInEditor': 'Editorda ochish',
    'tryTemplate': 'Template’ni sinash',
    'runTemplate': 'Template’ni ishga tushirish',
    'templateUnavailable': 'Bu dars uchun hali ishga tushadigan template yo‘q.',
    'lesson': 'dars',
    'lessons': 'dars',
    'steps': 'qadam',
    'visualOutput': 'Vizual natija',
    'visualOutputHint':
        'Template’ni ishga tushiring: chart, metrics va histogram workspace’ga keladi.',
    'tutorialLibrary': 'Tutorial kutubxonasi',
    'tutorialLibraryHint':
        'Yo‘nalishni tanlang, keyin ichidagi tajribani ishga tushiring.',
    'tutorialPanelTitle': 'TUTORIALAR',
    'tutorialPanelTooltip': 'Kvant ta’limi va tutoriallar',
    'stop': 'To‘xtatish',
    'run': 'Ishga tushirish',
    'running': 'Ishlamoqda',
    'workspaceReady': 'Quantum workspace tayyor',
    'envReady': 'Muhit tayyor',
    'envLoading': 'Muhit yuklanmoqda',
    'pythonRunning': 'Python ishlamoqda',
    'engineIdle': 'Engine bo‘sh',
    'controlCenter': 'KET STUDIO / BOSHQARUV MARKAZI',
    'workspaceTitle': 'Kvant tahlil workspace’i',
    'workspaceSubtitle':
        'Python tajribalarini yozing, lokal ishga tushiring va kvant natijalarini bitta desktop workspace’da tekshiring.',
    'scripts': 'Skriptlar',
    'scriptsHint': 'Python va kvant jarayonlari',
    'panels': 'Panellar',
    'panelsHint': 'Inspector, metrics va tarix',
    'execution': 'Ishga tushirish',
    'executionHint': 'Lokal ishga tushiring va natijani ko‘ring',
    'actions': 'AMALLAR',
    'newFile': 'Yangi fayl',
    'newFileHint': 'Yangi tajriba yoki yordamchi skript boshlang.',
    'openFolder': 'Papka ochish',
    'openFolderHint': 'Diskdagi mavjud workspace’ni yuklang.',
    'tryDemo': 'Demo sinash',
    'tryDemoHint': 'Tayyor vizualizatsiya namunasini oching.',
    'workspace': 'WORKSPACE',
    'projectState': 'Loyiha holati',
    'projectStateHint':
        'Hali so‘nggi fayllar yo‘q. Birinchi workspace’ni yarating.',
    'visualization': 'Vizualizatsiya',
    'visualizationHint':
        'Skriptni ishga tushirib, inspector, chart va tarixni ko‘ring.',
    'environmentHintWelcome':
        'Python manzili va paketlarni IDE ichidan boshqaring.',
    'quantumTemplates': 'KVANT TEMPLATE’LARI',
    'quantumTemplatesHint':
        'Bo‘sh editordan boshlamasdan, tayyor misolni tanlang.',
    'learningResources': 'O‘rganish resurslari',
    'quantumHardware': 'Kvant qurilmalari',
  };
}
