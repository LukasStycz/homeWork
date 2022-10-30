class Subject {
  Subject({this.title = 'none'});
  final String title;
}

Subject mon1 = Subject();
Subject mon2 = Subject();
Subject mon3 = Subject(title: 'Matematyka');
Subject mon4 = Subject(title: 'Muzyka');
Subject mon5 = Subject(title: 'Historia');
Subject mon6 = Subject(title: 'Jezyk Polski');
Subject mon7 = Subject(title: 'Przyroda');
Subject mon8 = Subject(title: 'WF');

Subject tue1 = Subject(title: 'WF');
Subject tue2 = Subject(title: 'Jezyk Polski');
Subject tue3 = Subject(title: 'Religia');
Subject tue4 = Subject(title: 'Jezyk Niemiecki');
Subject tue5 = Subject(title: 'Matematyka');
Subject tue6 = Subject(title: 'Projekt');
Subject tue7 = Subject();
Subject tue8 = Subject();

Subject wed1 = Subject(title: 'WF');
Subject wed2 = Subject(title: 'Jezyk Angielski');
Subject wed3 = Subject(title: 'Jezyk Polski');
Subject wed4 = Subject(title: 'Jezyk Niemiecki');
Subject wed5 = Subject(title: 'Wyczowanie do Życia w Rodzinie');
Subject wed6 = Subject(title: 'logopedia');
Subject wed7 = Subject(title: 'Korekcyjno-Kompensacyjne');
Subject wed8 = Subject();

Subject thu1 = Subject(title: 'Jezyk Polski');
Subject thu2 = Subject(title: 'Religia');
Subject thu3 = Subject(title: 'Jezyk Angielski');
Subject thu4 = Subject(title: 'Matematyka');
Subject thu5 = Subject(title: 'Plastyka');
Subject thu6 = Subject(title: 'Technika');
Subject thu7 = Subject(title: 'WF');
Subject thu8 = Subject();

Subject fri1 = Subject(title: 'Jezyk Polski');
Subject fri2 = Subject(title: 'Informatyka');
Subject fri3 = Subject(title: 'Matematyka');
Subject fri4 = Subject(title: 'Jezyk Angielski');
Subject fri5 = Subject(title: 'Wyczowawcza');
Subject fri6 = Subject(title: 'Przyroda');
Subject fri7 = Subject();
Subject fri8 = Subject();

final List<Subject> monday = [mon1, mon2, mon3, mon4, mon5, mon6, mon7, mon8];
final List<Subject> tuesday = [tue1, tue2, tue3, tue4, tue5, tue6, tue7, tue8];
final List<Subject> wednesday = [ wed1, wed2, wed3, wed4, wed5, wed6, wed7, wed8];
final List<Subject> thursday = [thu1, thu2, thu3, thu4, thu5, thu6, thu7, thu8];
final List<Subject> friday = [fri1, fri2, fri3, fri4, fri5, fri6, fri7, fri8];
