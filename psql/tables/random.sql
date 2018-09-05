CREATE TABLE random_words (
  word text unique not null,
  start boolean not null
);

CREATE FUNCTION generate_awesome_word() RETURNS text AS $$
  SELECT
    (SELECT word FROM random_words where start OFFSET floor(random()*99) LIMIT 1) ||
    '-' ||
    (SELECT word FROM random_words where not start OFFSET floor(random()*231) LIMIT 1) ||
    '-' ||
    ((random()*1000)::int)::text;
$$ LANGUAGE sql STABLE SET search_path FROM CURRENT;

INSERT INTO random_words VALUES
('admiring', true),
('adoring', true),
('affectionate', true),
('agitated', true),
('amazing', true),
('angry', true),
('awesome', true),
('blissful', true),
('boring', true),
('brave', true),
('charming', true),
('clever', true),
('cocky', true),
('cool', true),
('compassionate', true),
('competent', true),
('condescending', true),
('confident', true),
('cranky', true),
('crazy', true),
('dazzling', true),
('determined', true),
('distracted', true),
('dreamy', true),
('eager', true),
('ecstatic', true),
('elastic', true),
('elated', true),
('elegant', true),
('eloquent', true),
('epic', true),
('fervent', true),
('festive', true),
('flamboyant', true),
('focused', true),
('friendly', true),
('frosty', true),
('gallant', true),
('gifted', true),
('goofy', true),
('gracious', true),
('happy', true),
('hardcore', true),
('heuristic', true),
('hopeful', true),
('hungry', true),
('infallible', true),
('inspiring', true),
('jolly', true),
('jovial', true),
('keen', true),
('kind', true),
('laughing', true),
('loving', true),
('lucid', true),
('magical', true),
('mystifying', true),
('modest', true),
('musing', true),
('naughty', true),
('nervous', true),
('nifty', true),
('nostalgic', true),
('objective', true),
('optimistic', true),
('peaceful', true),
('pedantic', true),
('pensive', true),
('practical', true),
('priceless', true),
('quirky', true),
('quizzical', true),
('recursing', true),
('relaxed', true),
('reverent', true),
('romantic', true),
('sad', true),
('serene', true),
('sharp', true),
('silly', true),
('sleepy', true),
('stoic', true),
('stupefied', true),
('suspicious', true),
('sweet', true),
('tender', true),
('thirsty', true),
('trusting', true),
('unruffled', true),
('upbeat', true),
('vibrant', true),
('vigilant', true),
('vigorous', true),
('wizardly', true),
('wonderful', true),
('xenodochial', true),
('youthful', true),
('zealous', true),
('zen', true),
('albattani', false),
('allen', false),
('almeida', false),
('antonelli', false),
('agnesi', false),
('archimedes', false),
('ardinghelli', false),
('aryabhata', false),
('austin', false),
('babbage', false),
('banach', false),
('banzai', false),
('bardeen', false),
('bartik', false),
('bassi', false),
('beaver', false),
('bell', false),
('benz', false),
('bhabha', false),
('bhaskara', false),
('blackburn', false),
('blackwell', false),
('bohr', false),
('booth', false),
('borg', false),
('bose', false),
('boyd', false),
('brahmagupta', false),
('brattain', false),
('brown', false),\
('buck', false),
('burnell', false),
('cannon', false),
('carson', false),
('cartwright', false),
('chandrasekhar', false),
('chaplygin', false),
('chatelet', false),
('chatterjee', false),
('chebyshev', false),
('cocks', false),
('cohen', false),
('chaum', false),
('clarke', false),
('colden', false),
('cori', false),
('cray', false),
('curran', false),
('curie', false),
('darwin', false),
('davinci', false),
('dewdney', false),
('dhawan', false),
('diffie', false),
('dijkstra', false),
('dirac', false),
('driscoll', false),
('dubinsky', false),
('easley', false),
('edison', false),
('einstein', false),
('elbakyan', false),
('elgamal', false),
('elion', false),
('ellis', false),
('engelbart', false),
('euclid', false),
('euler', false),
('faraday', false),
('feistel', false),
('fermat', false),
('fermi', false),
('feynman', false),
('franklin', false),
('gagarin', false),
('galileo', false),
('galois', false),
('ganguly', false),
('gates', false),
('gauss', false),
('germain', false),
('goldberg', false),
('goldstine', false),
('goldwasser', false),
('golick', false),
('goodall', false),
('greider', false),
('grothendieck', false),
('haibt', false),
('hamilton', false),
('haslett', false),
('hawking', false),
('hellman', false),
('heisenberg', false),
('hermann', false),
('herschel', false),
('hertz', false),
('heyrovsky', false),
('hodgkin', false),
('hofstadter', false),
('hoover', false),
('hopper', false),
('hugle', false),
('hypatia', false),
('ishizaka', false),
('jackson', false),
('jang', false),
('jennings', false),
('jepsen', false),
('johnson', false),
('joliot', false),
('jones', false),
('kalam', false),
('kapitsa', false),
('kare', false),
('keldysh', false),
('keller', false),
('kepler', false),
('khayyam', false),
('khorana', false),
('kilby', false),
('kirch', false),
('knuth', false),
('kowalevski', false),
('lalande', false),
('lamarr', false),
('lamport', false),
('leakey', false),
('leavitt', false),
('lederberg', false),
('lehmann', false),
('lewin', false),
('lichterman', false),
('liskov', false),
('lovelace', false),
('lumiere', false),
('mahavira', false),
('margulis', false),
('matsumoto', false),
('maxwell', false),
('mayer', false),
('mccarthy', false),
('mcclintock', false),
('mclaren', false),
('mclean', false),
('mcnulty', false),
('mendel', false),
('mendeleev', false),
('meitner', false),
('meninsky', false),
('merkle', false),
('mestorf', false),
('minsky', false),
('mirzakhani', false),
('moore', false),
('morse', false),
('murdock', false),
('moser', false),
('napier', false),
('nash', false),
('neumann', false),
('newton', false),
('nightingale', false),
('nobel', false),
('noether', false),
('northcutt', false),
('noyce', false),
('panini', false),
('pare', false),
('pascal', false),
('pasteur', false),
('payne', false),
('perlman', false),
('pike', false),
('poincare', false),
('poitras', false),
('proskuriakova', false),
('ptolemy', false),
('raman', false),
('ramanujan', false),
('ride', false),
('montalcini', false),
('ritchie', false),
('rhodes', false),
('robinson', false),
('roentgen', false),
('rosalind', false),
('rubin', false),
('saha', false),
('sammet', false),
('sanderson', false),
('shannon', false),
('shaw', false),
('shirley', false),
('shockley', false),
('shtern', false),
('sinoussi', false),
('snyder', false),
('solomon', false),
('spence', false),
('sutherland', false),
('stallman', false),
('stonebraker', false),
('swanson', false),
('swartz', false),
('swirles', false),
('taussig', false),
('tereshkova', false),
('tesla', false),
('tharp', false),
('thompson', false),
('torvalds', false),
('tu', false),
('turing', false),
('varahamihira', false),
('vaughan', false),
('visvesvaraya', false),
('volhard', false),
('villani', false),
('wescoff', false),
('wiles', false),
('williams', false),
('williamson', false),
('wilson', false),
('wing', false),
('wozniak', false),
('wright', false),
('wu', false),
('yalow', false),
('yonath', false),
('zhukovsky', false);
