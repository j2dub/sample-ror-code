# == Schema Information
#
# Table name: users
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#
require 'digest'
require 'uri_validator'
class User < ActiveRecord::Base

  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation, :first_name, :last_name, :tag_list, :tag, :tags, :website, :gender, :phone, :deleted, :deleted_at, :verified, :verifed_code
  
  # identifies user who tags as part of the acts-as-taggable-on gem
  acts_as_tagger
  


  has_many :microposts, :dependent => :destroy
  has_many :items, :dependent => :destroy
  has_many :circles, :foreign_key => "user_id",
                     :dependent => :destroy                   
  has_many :likes, :foreign_key => "user_id",
                     :dependent => :destroy                     
  has_many :locations, :foreign_key => "user_id",
                     :dependent => :destroy
  has_many :filters, :foreign_key => "user_id",
                     :dependent => :destroy
  has_many :relationships, :foreign_key => "follower_id",
                           :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed
  has_many :reverse_relationships, :foreign_key => "followed_id",
                                   :class_name => "Relationship",
                                   :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower
  has_many :pings, :foreign_key => "user_id",
                     :dependent => :destroy 

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
 
  can_skip_validation_for :name, :password, :email, :phone, :website
  

  validates :name, :presence => true, :unless => :skip_name_validation?,
				   :format  => { with: /\A[a-z0-9_]+\z/ },
                   :length   => { :maximum => 50 },
                   :length   => { :minimum => 5 },
                   :uniqueness => { :case_sensitive => false }
                  # :scope => [:id, :deleted_at]
  validates_format_of :name, :with => /^[A-Za-z\d_]+$/, :message => "must be alphanumeric with no spaces", :unless => :skip_name_validation?
  #validates :website, :presence => true, :uri => { :format => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?([\/].*)?$)/ix }, :unless => :skip_website_validation?
  validates :email, :presence => true,
                    :format   => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }, :unless => :skip_email_validation?
  validates :password, :presence       => true,
                       :confirmation   => true,
                       :length         => { :within => 6..40 },
                       :unless => :skip_password_validation?
  #validates_format_of :password, :with => /^(?=.\d)(?=.([a-z]|[A-Z]))([\x20-\x7E]){6,40}$/, :message => "must include one number, one letter and be between 6 and 40 characters", :unless => :skip_password_validation?
  before_save :encrypt_password, :unless => Proc.new { |u| u.password.blank? }
  #validates_format_of :phone, :with => %r{(1)?(?:-)?(?:\(|-)?([\d]{3})(?:\.|\-|\))([\d]{3})(?:\.|\-)([\d]{4})(?: ?x([\d]{3,5}))?}, :message => "phone number must be in a valid format."
  #validates_format_of :phone, :with =>  /\d[0-9]\)*\z/ , :message => "Only positive number without spaces are allowed"



  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
    # Compare encrypted_password with the encrypted version of
    # submitted_password.
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email, :conditions => ['deleted = ?', 'N'])
    #user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id, :conditions => ['deleted = ?', 'N'])
    #user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end

  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end
  
  
    def mark_deleted
	  self.deleted_at = Time.now
	  self.deleted_at = 'Y'
	end
	 
	def mark_deleted!
	  mark_deleted
	  self.save
	end
  


  def feed
    # This is preliminary. See Chapter 12 for the full implementation.
    # old-(for picking micropost of said user)------Micropost.where("user_id = ?", id)
    Micropost.from_users_followed_by(self)
  end

	def check_for_stop_words
		#checks for stopwords
		lines = params[:user].strip
		stop_words = %w{anus arse arsehole ass ass-hat ass-jabber ass-pirate assbag assbandit assbanger assbite assclown asscock asscracker asses assface assfuck assfucker assgoblin asshat asshead asshole asshopper assjacker asslick asslicker assmonkey assmunch assmuncher assnigger asspirate assshit assshole asssucker asswad asswipe homosexual butt idiot jerk buttlicker bampot bastard beaner bitch bitchass bitches bitchtits bitchy blowjob blowjob bollocks bollox boner erection brotherfucker bullshit bumblefuck buttplug butt-pirate buttfucka buttfucker cameltoe carpetmuncher chinc chink choad chode clit clitface clitfuck clusterfuck cock cockass cockbite cockburger cockface cockfucker cockhead cockjockey cockknoker cockmaster cockmongler cockmongruel cockmonkey cockmuncher cocknose cocknugget cockshit cocksmith cocksmoker cocksniffer cocksucker cockwaffle coochie coochy coon cooter cracker cum cumbubble cumdumpster cumguzzler cumjockey cumslut cumtart cunnie cunnilingus cunt cuntass cuntface cunthole cuntlicker cuntrag cuntslut dago damn deggo dick dickbag dickbeaters dickface dickfuck dickfucker dickhead dickhole dickjuice dickmilk dickmonger dicks dickslap dicksucker dicksucking dickwad dickweasel dickweed dickwod dike dildo dipshit doochbag dookie douche douchebag douchewaffle dumass dumbasses dumbass dumbfuck dumbshit dumshit dyke fag fagbag fagfucker faggit faggots faggotcock fagtards fatass fellatio feltch flamers fuck fuckass fuckbag fuckboy fuckbrain fuckbutt fucked fucker fuckersucker fuckface fuckhead fuckhole fuckin fucking fucknut fucknutt fuckoff fucks fuckstick fucktard fucktart fuckup fuckwad fuckwit fuckwitt fudgepacker gay gayass gaybob gaydo gayfuck gayfuckist gaylord gaytard gaywad goddamn goddamnit gooch gook gringo guido handjob hardon heeb homo homodumbshit honkey humping jackass jap jerkoff jigaboo jizz junglebunny junglebunny kike kooch kootch kraut kunt kyke lameass lesbian lesbo lezzie mcfagget mick minge mothafucka mothafuckin motherfucker motherfucking muff muffdiver munging negro nigaboo nigga nigger niggerss nigletchild nutsack nutsack paki panooch pecker peckerhead penis penisfucker penispuffer piss pissed pissedoff pissflaps polesmoker pollock poon poonani poonany poontang porchmonkey porchmonkey prick punanny punta pussiess pussy pussylicking puto queef queer queerbait queerhole renob rimjob ruski retard sandnigger sandnigger schlong scrote shit shitass shitbag shitbagger shitbrains shitbreath shitcanned shitcunt shitdick shitface shitfaced shithead shithole shithouse shitspitter shitstain shitter shittiest shitting shitty shiz shiznit skank skeet skullfuck slut slutbag smeg snatch spic spick splooge spook suckass tard testicle thundercunt tit titfuck tits tittyfuck twat twatlips twatss twatwaffle unclefucker va-j-j vag vagina vjayjay wank wetback whore whorebag whoreface wop sex sexual sextoy genitals genitalia hussy ejaculate poop semen defecator jerk anus arsehole ass asshat assjabber ass-pirate assbag assbandit assbanger assbite assclown asscock asscracker asses assface assfuck assfucker assgoblin asshat asshead ass-hole asshopper assjacker asslick asslicker assmonkey assmunch assmuncher assnigger asspirate assshit asshole asssucker asswad asswipe homosexual butt idiot jerk buttlicker bampot bastard beaner bitch bitchass bitch-ass bitches bitchtits bitchy blowjob blow-job bollocks bollox boner erection brotherfucker bullshit bumblefuck buttplug butt-pirate buttfucka buttfucker cameltoe carpetmuncher chinc chink choad chode clit clitface clitfuck clusterfuck cock cockass cockbite cockburger cockface cockfucker cockhead cockjockey cockknoker cockmaster cockmongler cockmongruel cockmonkey cockmuncher cocknose cocknugget cockshit cocksmith cocksmoker cocksniffer cocksucker cockwaffle coochie coochy coon cooter cracker cum cumbubble cumdumpster cumguzzler cumjockey cumslut cumtart cunnie cunnilingus cunt cuntass cuntface cunthole cuntlicker cuntrag cuntslut dago damn deggo dick dickbag dickbeaters dickface dickfuck dickfucker dickhead dickhole dickjuice dickmilk dickmonger dicks dickslap dicksucker dicksucking dickwad dickweasel dickweed dickwod dike dildo dipshit doochbag dookie douche douche douchebag douchewaffle dumass dumbass dumb-ass dumbfuck dumbshit dumshit dyke fag fagbag fagfucker faggits faggot faggotcock fagtard fatass fellatio feltch flamer fucks fuckass fuckbag fuckboy fuckbrain fuckbutt fucked fucker fuckersucker fuckface fuckhead fuckhole fuckin fucking fucknut fucknutt fuckoff fucks fuckstick fucktard fucktart fuckup fuckwad fuckwit fuckwitt fudgepacker gays gayass gaybob gaydo gayfuck gayfuckist gaylord gaytard gaywad goddamn goddamnit gooch gook gringo guido handjob hardon heeb homo homodumbshit honkey humping jackass jap jerkoff jigaboo jizz junglebunny jungle-bunny kike kooch kootch kooter kraut kunt kyke lameass lesbian lesbo lezzie mcfagget mick minge muthafucka muthafuckin mutherfucker mutherfucking mothafucka mothafuckin motherfucker motherfucking muthafucka muthafuckin mutherfucker mutherfucking muff muffdiver munging negro nigaboo nigga niggas nigger niggers nigletchild nutsack nutsack paki panooch pecker peckerhead penis penisfucker penispuffer piss pissed pissedoff pissflaps polesmoker pollock poon poonani poonany poontang porchmonkey porch-monkey prick punanny punta pussie pussy pussylicking puto queef queer queerbait queerhole renob rimjob ruski retard sandnigger sand-nigger schlong scrote shit shitass shitbag shitbagger shitbrains shitbreath shitcanned shitcunt shitdick shitface shitfaced shithead shithole shithouse shitspitter shitstain shitter shittiest shitting shitty shiz shiznit skank skeet skullfuck slut slutbag smeg snatch spic spick splooge spook suckass tard testicle thundercunt tit titfuck tits tittyfuck twat twatlips twats twatwaffle unclefucker va-j-j vag vagina vjayjay wank wetback whore whorebag whoreface loser hoe hobag hobag hoebag hoebag cuntlicker cuntlicker ho-bag hoe-bag titty titties niger niggers niggas assholes nigggers asssholes assshole nigggas niggga nigggers pu$$y pusssy sandnigga sandnigga sand-nigga fart fagget piss pissy muthafucker muthafuck cumshot cumshot butthole junglebunnie cumlicker cumlicker cumface cuntwhore whorecunt fagot faget fagat fagget faggot faggat buttmunch}
		@user = lines.reject{|str|stop_words.include?(str)}
	end

  private

    def encrypt_password
      self.salt = make_salt unless has_password?(password)
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
    


end
