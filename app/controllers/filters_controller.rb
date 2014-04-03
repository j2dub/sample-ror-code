class FiltersController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy

  def index
        if signed_in?
		 @item = Item.new
	  end
	  
     #@filter = Filter.find(params[:id])
     #@filter = Filter.find(params[:id].keys)
     @user = current_user
     @filter = Filter.find_by_id(params[:id].keys)
     
     @filter_id = @filter.id
	 #@filter.owned_taggings
     #@filter.owned_tags   
     
       def tag_cloud
         @tags = Filter.tag_counts_on(:filtertags)
       end       
       
        		  @tags = Filter.find(@filter_id).tag_counts_on(:tags)
				  if @tags.empty? 
						   @tagsforfilter = ""
				  else
					   @tags.each do |tag| 
								 if @tagsforfilter.blank?
									@tagsforfilter = tag.name.to_s
								 else
									@tagsforfilter = @tagsforfilter.to_s + ", " + tag.name.to_s
								 end
						 end
				  end 	
				  
				  @tagscurrent = @tagsforfilter.gsub(",","").split.to_a
     
     if params[:newtags].nil?
     else
        lines = params[:newtags].to_s.gsub(","," ").gsub("  "," ")
		stop_words = %w{show edit create update destroy a by on for of are the with but me etc is and to my I has some in if am now he she it able about above abroad according accordingly across actually adj after afterwards again against ago ahead ain't aint all allow allows almost alone along alongside already also although always am amid amidst among amongst an and another any anybody anyhow anyone anything anyway anyways anywhere apart appear appreciate appropriate are aren't around as a's aside ask asking associated at available away awfully back backward backwards be became because become becomes becoming been before beforehand begin behind being believe below beside besides best better between beyond both brief but by came can cannot cant can't caption cause causes certain certainly changes clearly c'mon cmon co co. com come comes concerning consequently consider considering contain containing contains corresponding could couldn't couldnt course c's currently dare daren't darent definitely described despite did didn't didnt different directly do does doesn't doesnt doing done don't dont down downwards during each edu eg eight eighty either else elsewhere end ending enough entirely especially et etc even ever evermore every everybody everyone everything everywhere ex exactly example except fairly far farther few fewer fifth first five followed following follows for forever former formerly forth forward found four from further furthermore get gets getting given gives go goes going gone got gotten greetings had hadn't hadnt half happens hardly has hasn't hasnt have haven't havent having he he'd hed he'll hello help hence her here hereafter hereby herein here's hereupon hers herself he's heres hes hi him himself his hither hopefully how howbeit however hundred i'd id ie if ignored i'll ill im i'm immediate in inasmuch inc inc. indeed indicate indicated indicates inner inside insofar instead into inward is isn't isnt it it'd itd it'll itll its it's itself i've ive just k keep keeps kept know known knows last lately later latter latterly least less lest let let's lets like liked likely likewise little look looking looks low lower ltd made mainly make makes many may maybe mayn't maynt me mean meantime meanwhile merely might mightn't mine minus miss more moreover most mostly mr mrs much must mustn't musnt my myself name namely nd near nearly necessary need needn't neednt needs neither never neverf neverless nevertheless new next nine ninety no nobody non none nonetheless noone no-one nor normally not nothing notwithstanding novel now nowhere obviously of off often oh ok okay old on once one ones one's only onto opposite or other others otherwise ought oughtnt oughtn't our ours ourselves out outside over overall own particular particularly past per perhaps placed please plus possible presumably probably provided provides que quite qv rather rd re really reasonably recent recently regarding regardless regards relatively respectively right round said same saw say saying says second secondly see seeing seem seemed seeming seems seen self selves sensible sent serious seriously seven several shall shan't shant shart she she'd shed she'll she's shes should shouldn't shouldnt since six so some somebody someday somehow someone something sometime sometimes somewhat somewhere soon sorry specified specify specifying still sub such sup sure take taken taking tell tends th than thank thanks thanx that that'll thatll thats that's thats that've thatve the their theirs them themselves then thence there thereafter thereby there'd thered therefore therein there'll therell there're therere theres there's thereupon there've thereve these they they'd theyd they'll theyll they're theyre they've theyve thing things think third thirty this thorough thoroughly those though three through throughout thru thus till to together too took toward towards tried tries truly try trying t's ts twice two un under underneath undoing unfortunately unless unlike unlikely until unto up upon upwards us use used useful uses using usually v value various versus very via viz vs want wants was wasn't wasnt way we we'd wed welcome well we'll went were we're weren't werent we've weve what whatever what'll whatll what's whats what've whatve when whence whenever where whereafter whereas whereby wherein where's wheres whereupon wherever whether which whichever while whilst whither who who'd whod whoever whole who'll wholl whom whomever who's whos whose why will willing wish with within without wonder won't wont would wouldn't wouldnt yes yet you you'd youd you'll youll your youre you're yours yourself yourselves you've youve anus arse arsehole ass ass-hat ass-jabber ass-pirate assbag assbandit assbanger assbite assclown asscock asscracker asses assface assfuck assfucker assgoblin asshat asshead asshole asshopper assjacker asslick asslicker assmonkey assmunch assmuncher assnigger asspirate assshit assshole asssucker asswad asswipe homosexual butt idiot jerk buttlicker bampot bastard beaner bitch bitchass bitches bitchtits bitchy blowjob blowjob bollocks bollox boner erection brotherfucker bullshit bumblefuck buttplug butt-pirate buttfucka buttfucker cameltoe carpetmuncher chinc chink choad chode clit clitface clitfuck clusterfuck cock cockass cockbite cockburger cockface cockfucker cockhead cockjockey cockknoker cockmaster cockmongler cockmongruel cockmonkey cockmuncher cocknose cocknugget cockshit cocksmith cocksmoker cocksniffer cocksucker cockwaffle coochie coochy coon cooter cracker cum cumbubble cumdumpster cumguzzler cumjockey cumslut cumtart cunnie cunnilingus cunt cuntass cuntface cunthole cuntlicker cuntrag cuntslut dago damn deggo dick dickbag dickbeaters dickface dickfuck dickfucker dickhead dickhole dickjuice dickmilk dickmonger dicks dickslap dicksucker dicksucking dickwad dickweasel dickweed dickwod dike dildo dipshit doochbag dookie douche douchebag douchewaffle dumass dumbasses dumbass dumbfuck dumbshit dumshit dyke fag fagbag fagfucker faggit faggots faggotcock fagtards fatass fellatio feltch flamers fuck fuckass fuckbag fuckboy fuckbrain fuckbutt fucked fucker fuckersucker fuckface fuckhead fuckhole fuckin fucking fucknut fucknutt fuckoff fucks fuckstick fucktard fucktart fuckup fuckwad fuckwit fuckwitt fudgepacker gay gayass gaybob gaydo gayfuck gayfuckist gaylord gaytard gaywad goddamn goddamnit gooch gook gringo guido handjob hardon heeb homo homodumbshit honkey humping jackass jap jerkoff jigaboo jizz junglebunny junglebunny kike kooch kootch kraut kunt kyke lameass lesbian lesbo lezzie mcfagget mick minge mothafucka mothafuckin motherfucker motherfucking muff muffdiver munging negro nigaboo nigga nigger niggerss nigletchild nutsack nutsack paki panooch pecker peckerhead penis penisfucker penispuffer piss pissed pissedoff pissflaps polesmoker pollock poon poonani poonany poontang porchmonkey porchmonkey prick punanny punta pussiess pussy pussylicking puto queef queer queerbait queerhole renob rimjob ruski retard sandnigger sandnigger schlong scrote shit shitass shitbag shitbagger shitbrains shitbreath shitcanned shitcunt shitdick shitface shitfaced shithead shithole shithouse shitspitter shitstain shitter shittiest shitting shitty shiz shiznit skank skeet skullfuck slut slutbag smeg snatch spic spick splooge spook suckass tard testicle thundercunt tit titfuck tits tittyfuck twat twatlips twatss twatwaffle unclefucker va-j-j vag vagina vjayjay wank wetback whore whorebag whoreface wop sex sexual sextoy genitals genitalia hussy ejaculate poop semen defecator jerk anus arsehole ass asshat assjabber ass-pirate assbag assbandit assbanger assbite assclown asscock asscracker asses assface assfuck assfucker assgoblin asshat asshead ass-hole asshopper assjacker asslick asslicker assmonkey assmunch assmuncher assnigger asspirate assshit asshole asssucker asswad asswipe homosexual butt idiot jerk buttlicker bampot bastard beaner bitch bitchass bitch-ass bitches bitchtits bitchy blowjob blow-job bollocks bollox boner erection brotherfucker bullshit bumblefuck buttplug butt-pirate buttfucka buttfucker cameltoe carpetmuncher chinc chink choad chode clit clitface clitfuck clusterfuck cock cockass cockbite cockburger cockface cockfucker cockhead cockjockey cockknoker cockmaster cockmongler cockmongruel cockmonkey cockmuncher cocknose cocknugget cockshit cocksmith cocksmoker cocksniffer cocksucker cockwaffle coochie coochy coon cooter cracker cum cumbubble cumdumpster cumguzzler cumjockey cumslut cumtart cunnie cunnilingus cunt cuntass cuntface cunthole cuntlicker cuntrag cuntslut dago damn deggo dick dickbag dickbeaters dickface dickfuck dickfucker dickhead dickhole dickjuice dickmilk dickmonger dicks dickslap dicksucker dicksucking dickwad dickweasel dickweed dickwod dike dildo dipshit doochbag dookie douche douche douchebag douchewaffle dumass dumbass dumb-ass dumbfuck dumbshit dumshit dyke fag fagbag fagfucker faggits faggot faggotcock fagtard fatass fellatio feltch flamer fucks fuckass fuckbag fuckboy fuckbrain fuckbutt fucked fucker fuckersucker fuckface fuckhead fuckhole fuckin fucking fucknut fucknutt fuckoff fucks fuckstick fucktard fucktart fuckup fuckwad fuckwit fuckwitt fudgepacker gays gayass gaybob gaydo gayfuck gayfuckist gaylord gaytard gaywad goddamn goddamnit gooch gook gringo guido handjob hardon heeb homo homodumbshit honkey humping jackass jap jerkoff jigaboo jizz junglebunny jungle-bunny kike kooch kootch kooter kraut kunt kyke lameass lesbian lesbo lezzie mcfagget mick minge muthafucka muthafuckin mutherfucker mutherfucking mothafucka mothafuckin motherfucker motherfucking muthafucka muthafuckin mutherfucker mutherfucking muff muffdiver munging negro nigaboo nigga niggas nigger niggers nigletchild nutsack nutsack paki panooch pecker peckerhead penis penisfucker penispuffer piss pissed pissedoff pissflaps polesmoker pollock poon poonani poonany poontang porchmonkey porch-monkey prick punanny punta pussie pussy pussylicking puto queef queer queerbait queerhole renob rimjob ruski retard sandnigger sand-nigger schlong scrote shit shitass shitbag shitbagger shitbrains shitbreath shitcanned shitcunt shitdick shitface shitfaced shithead shithole shithouse shitspitter shitstain shitter shittiest shitting shitty shiz shiznit skank skeet skullfuck slut slutbag smeg snatch spic spick splooge spook suckass tard testicle thundercunt tit titfuck tits tittyfuck twat twatlips twats twatwaffle unclefucker va-j-j vag vagina vjayjay wank wetback whore whorebag whoreface loser hoe hobag hobag hoebag hoebag cuntlicker cuntlicker ho-bag hoe-bag titty titties niger niggers niggas assholes nigggers asssholes assshole nigggas niggga nigggers pu$$y pusssy sandnigga sandnigga sand-nigga fart fagget piss pissy muthafucker muthafuck cumshot cumshot butthole junglebunnie cumlicker cumlicker cumface cuntwhore whorecunt fagot faget fagat fagget faggot faggat buttmunch}
		@goodtags = lines.split.reject{|str|stop_words.include?(str)}
		@goodtagsyes = @tagscurrent + @goodtags
		
        #@filter.tag(@filter, :with => @goodtags, :on => :tags)
        #---> neeed to use this line somehow   @user.tag(@receipe, :with => :ingredients, :on => :ingredients)
        
        #@user.tag(@filter_id, :with => @goodtagsyes, :on => :tags)
        @filter.tag_list = @goodtagsyes
		@filter.save

        		#@goodtags = @goodtags.to_s.gsub(" ",",") || ''
     end     
	  
	  #@filter_id = params[:id].nil?
	  
	  if not @filter_id.nil?

	    flash[:success] = "tags updated! " + @filter_id.to_s + @goodtagsyes.to_s + "{" + @tagscurrent.to_s
	    redirect_to :back
	  end
	  
	  #redirect_to :back	  
	  
	  
  end
  
  def new
  end   
  
  def show
      if signed_in?
		 @item = Item.new
	  end
	  
	@filters = Filter.find(params[:id])
	@status = @filters.public
	
	if @status == "Y"
		Filter.update(params[:id], :public => "N")
	else 
	   if @status == "N"
	    Filter.update(params[:id], :public => "Y")
	   end
	end
	  
    flash[:success] = "filter status updated [x] close"
    #flash[:notice] = fading_flash_message("Thank you for your message.", 5)
    redirect_to :back
    
    # @tags = Filter.find(params[:id]).tag_counts_on(:tags)
    # @message = @tags.each do |tag| tag.name
    #  if @tags.empty? 
    #           tagsforfilter = ""
    #  else
    #       @tags.each do |tag| 
	#				 if @tagsforfilter.nil?
	#					@tagsforfilter = tag.name.to_s
	#				 else
	#					@tagsforfilter = @tagsforfilter.to_s+", "+tag.name.to_s
	#				 end
	#          end
	#  end 
	#  end     
     
	  
  end

  def create
    
      if signed_in?
		 @item = Item.new
	  end
	  
	  #if current_user.filters.build(params[:name]).nil?
	  #if params[:name].nil?
	  #if params[:name].nil?
	#		  flash[:error] = "filter must have a name" + params[:name].to_s
	#		  redirect_to :back	  
	 # else
	  

			@filter = current_user.filters.build(params[:filter])
			@user = current_user
			@name = current_user.filters.build(params[:name])	  
							
			if @filter.save
			
			  @temp_name = @filter.name

			  flash[:success] = "filter [" + @temp_name + "] created [x] close"
			  #redirect_to root_path
			  #redirect_to 'settings/filters'
			  redirect_to :back
			  #render 'settings/filters'
			else
			
			  flash[:error] = "filter must have a name [x] close"
			   redirect_to :back

			end
			
		#end
			
		
		
  end

  def update
      if signed_in?
		 @item = Item.new
	  end  
     
     #@filter_id = params[:filter_id].to_i
     #@filter = Filter.find(@filter_id)
     @filter = Filter.find(params[:id])
	 @filter.owned_taggings
     @filter.owned_tags     
     
     if params[:newtags].nil?
     else
        lines = params[:newtags].to_s.gsub(","," ").gsub("  "," ")
		stop_words = %w{show edit create update destroy a by on for of are the with but me etc is and to my I has some in if am now he she it able about above abroad according accordingly across actually adj after afterwards again against ago ahead ain't aint all allow allows almost alone along alongside already also although always am amid amidst among amongst an and another any anybody anyhow anyone anything anyway anyways anywhere apart appear appreciate appropriate are aren't around as a's aside ask asking associated at available away awfully back backward backwards be became because become becomes becoming been before beforehand begin behind being believe below beside besides best better between beyond both brief but by came can cannot cant can't caption cause causes certain certainly changes clearly c'mon cmon co co. com come comes concerning consequently consider considering contain containing contains corresponding could couldn't couldnt course c's currently dare daren't darent definitely described despite did didn't didnt different directly do does doesn't doesnt doing done don't dont down downwards during each edu eg eight eighty either else elsewhere end ending enough entirely especially et etc even ever evermore every everybody everyone everything everywhere ex exactly example except fairly far farther few fewer fifth first five followed following follows for forever former formerly forth forward found four from further furthermore get gets getting given gives go goes going gone got gotten greetings had hadn't hadnt half happens hardly has hasn't hasnt have haven't havent having he he'd hed he'll hello help hence her here hereafter hereby herein here's hereupon hers herself he's heres hes hi him himself his hither hopefully how howbeit however hundred i'd id ie if ignored i'll ill im i'm immediate in inasmuch inc inc. indeed indicate indicated indicates inner inside insofar instead into inward is isn't isnt it it'd itd it'll itll its it's itself i've ive just k keep keeps kept know known knows last lately later latter latterly least less lest let let's lets like liked likely likewise little look looking looks low lower ltd made mainly make makes many may maybe mayn't maynt me mean meantime meanwhile merely might mightn't mine minus miss more moreover most mostly mr mrs much must mustn't musnt my myself name namely nd near nearly necessary need needn't neednt needs neither never neverf neverless nevertheless new next nine ninety no nobody non none nonetheless noone no-one nor normally not nothing notwithstanding novel now nowhere obviously of off often oh ok okay old on once one ones one's only onto opposite or other others otherwise ought oughtnt oughtn't our ours ourselves out outside over overall own particular particularly past per perhaps placed please plus possible presumably probably provided provides que quite qv rather rd re really reasonably recent recently regarding regardless regards relatively respectively right round said same saw say saying says second secondly see seeing seem seemed seeming seems seen self selves sensible sent serious seriously seven several shall shan't shant shart she she'd shed she'll she's shes should shouldn't shouldnt since six so some somebody someday somehow someone something sometime sometimes somewhat somewhere soon sorry specified specify specifying still sub such sup sure take taken taking tell tends th than thank thanks thanx that that'll thatll thats that's thats that've thatve the their theirs them themselves then thence there thereafter thereby there'd thered therefore therein there'll therell there're therere theres there's thereupon there've thereve these they they'd theyd they'll theyll they're theyre they've theyve thing things think third thirty this thorough thoroughly those though three through throughout thru thus till to together too took toward towards tried tries truly try trying t's ts twice two un under underneath undoing unfortunately unless unlike unlikely until unto up upon upwards us use used useful uses using usually v value various versus very via viz vs want wants was wasn't wasnt way we we'd wed welcome well we'll went were we're weren't werent we've weve what whatever what'll whatll what's whats what've whatve when whence whenever where whereafter whereas whereby wherein where's wheres whereupon wherever whether which whichever while whilst whither who who'd whod whoever whole who'll wholl whom whomever who's whos whose why will willing wish with within without wonder won't wont would wouldn't wouldnt yes yet you you'd youd you'll youll your youre you're yours yourself yourselves you've youve anus arse arsehole ass ass-hat ass-jabber ass-pirate assbag assbandit assbanger assbite assclown asscock asscracker asses assface assfuck assfucker assgoblin asshat asshead asshole asshopper assjacker asslick asslicker assmonkey assmunch assmuncher assnigger asspirate assshit assshole asssucker asswad asswipe homosexual butt idiot jerk buttlicker bampot bastard beaner bitch bitchass bitches bitchtits bitchy blowjob blowjob bollocks bollox boner erection brotherfucker bullshit bumblefuck buttplug butt-pirate buttfucka buttfucker cameltoe carpetmuncher chinc chink choad chode clit clitface clitfuck clusterfuck cock cockass cockbite cockburger cockface cockfucker cockhead cockjockey cockknoker cockmaster cockmongler cockmongruel cockmonkey cockmuncher cocknose cocknugget cockshit cocksmith cocksmoker cocksniffer cocksucker cockwaffle coochie coochy coon cooter cracker cum cumbubble cumdumpster cumguzzler cumjockey cumslut cumtart cunnie cunnilingus cunt cuntass cuntface cunthole cuntlicker cuntrag cuntslut dago damn deggo dick dickbag dickbeaters dickface dickfuck dickfucker dickhead dickhole dickjuice dickmilk dickmonger dicks dickslap dicksucker dicksucking dickwad dickweasel dickweed dickwod dike dildo dipshit doochbag dookie douche douchebag douchewaffle dumass dumbasses dumbass dumbfuck dumbshit dumshit dyke fag fagbag fagfucker faggit faggots faggotcock fagtards fatass fellatio feltch flamers fuck fuckass fuckbag fuckboy fuckbrain fuckbutt fucked fucker fuckersucker fuckface fuckhead fuckhole fuckin fucking fucknut fucknutt fuckoff fucks fuckstick fucktard fucktart fuckup fuckwad fuckwit fuckwitt fudgepacker gay gayass gaybob gaydo gayfuck gayfuckist gaylord gaytard gaywad goddamn goddamnit gooch gook gringo guido handjob hardon heeb homo homodumbshit honkey humping jackass jap jerkoff jigaboo jizz junglebunny junglebunny kike kooch kootch kraut kunt kyke lameass lesbian lesbo lezzie mcfagget mick minge mothafucka mothafuckin motherfucker motherfucking muff muffdiver munging negro nigaboo nigga nigger niggerss nigletchild nutsack nutsack paki panooch pecker peckerhead penis penisfucker penispuffer piss pissed pissedoff pissflaps polesmoker pollock poon poonani poonany poontang porchmonkey porchmonkey prick punanny punta pussiess pussy pussylicking puto queef queer queerbait queerhole renob rimjob ruski retard sandnigger sandnigger schlong scrote shit shitass shitbag shitbagger shitbrains shitbreath shitcanned shitcunt shitdick shitface shitfaced shithead shithole shithouse shitspitter shitstain shitter shittiest shitting shitty shiz shiznit skank skeet skullfuck slut slutbag smeg snatch spic spick splooge spook suckass tard testicle thundercunt tit titfuck tits tittyfuck twat twatlips twatss twatwaffle unclefucker va-j-j vag vagina vjayjay wank wetback whore whorebag whoreface wop sex sexual sextoy genitals genitalia hussy ejaculate poop semen defecator jerk anus arsehole ass asshat assjabber ass-pirate assbag assbandit assbanger assbite assclown asscock asscracker asses assface assfuck assfucker assgoblin asshat asshead ass-hole asshopper assjacker asslick asslicker assmonkey assmunch assmuncher assnigger asspirate assshit asshole asssucker asswad asswipe homosexual butt idiot jerk buttlicker bampot bastard beaner bitch bitchass bitch-ass bitches bitchtits bitchy blowjob blow-job bollocks bollox boner erection brotherfucker bullshit bumblefuck buttplug butt-pirate buttfucka buttfucker cameltoe carpetmuncher chinc chink choad chode clit clitface clitfuck clusterfuck cock cockass cockbite cockburger cockface cockfucker cockhead cockjockey cockknoker cockmaster cockmongler cockmongruel cockmonkey cockmuncher cocknose cocknugget cockshit cocksmith cocksmoker cocksniffer cocksucker cockwaffle coochie coochy coon cooter cracker cum cumbubble cumdumpster cumguzzler cumjockey cumslut cumtart cunnie cunnilingus cunt cuntass cuntface cunthole cuntlicker cuntrag cuntslut dago damn deggo dick dickbag dickbeaters dickface dickfuck dickfucker dickhead dickhole dickjuice dickmilk dickmonger dicks dickslap dicksucker dicksucking dickwad dickweasel dickweed dickwod dike dildo dipshit doochbag dookie douche douche douchebag douchewaffle dumass dumbass dumb-ass dumbfuck dumbshit dumshit dyke fag fagbag fagfucker faggits faggot faggotcock fagtard fatass fellatio feltch flamer fucks fuckass fuckbag fuckboy fuckbrain fuckbutt fucked fucker fuckersucker fuckface fuckhead fuckhole fuckin fucking fucknut fucknutt fuckoff fucks fuckstick fucktard fucktart fuckup fuckwad fuckwit fuckwitt fudgepacker gays gayass gaybob gaydo gayfuck gayfuckist gaylord gaytard gaywad goddamn goddamnit gooch gook gringo guido handjob hardon heeb homo homodumbshit honkey humping jackass jap jerkoff jigaboo jizz junglebunny jungle-bunny kike kooch kootch kooter kraut kunt kyke lameass lesbian lesbo lezzie mcfagget mick minge muthafucka muthafuckin mutherfucker mutherfucking mothafucka mothafuckin motherfucker motherfucking muthafucka muthafuckin mutherfucker mutherfucking muff muffdiver munging negro nigaboo nigga niggas nigger niggers nigletchild nutsack nutsack paki panooch pecker peckerhead penis penisfucker penispuffer piss pissed pissedoff pissflaps polesmoker pollock poon poonani poonany poontang porchmonkey porch-monkey prick punanny punta pussie pussy pussylicking puto queef queer queerbait queerhole renob rimjob ruski retard sandnigger sand-nigger schlong scrote shit shitass shitbag shitbagger shitbrains shitbreath shitcanned shitcunt shitdick shitface shitfaced shithead shithole shithouse shitspitter shitstain shitter shittiest shitting shitty shiz shiznit skank skeet skullfuck slut slutbag smeg snatch spic spick splooge spook suckass tard testicle thundercunt tit titfuck tits tittyfuck twat twatlips twats twatwaffle unclefucker va-j-j vag vagina vjayjay wank wetback whore whorebag whoreface loser hoe hobag hobag hoebag hoebag cuntlicker cuntlicker ho-bag hoe-bag titty titties niger niggers niggas assholes nigggers asssholes assshole nigggas niggga nigggers pu$$y pusssy sandnigga sandnigga sand-nigga fart fagget piss pissy muthafucker muthafuck cumshot cumshot butthole junglebunnie cumlicker cumlicker cumface cuntwhore whorecunt fagot faget fagat fagget faggot faggat buttmunch}
		@goodtags = lines.split.reject{|str|stop_words.include?(str)}
        @user.tag(@filter, :with => @goodtags, :on => :tags)
        		#@goodtags = @goodtags.to_s.gsub(" ",",") || ''
     end     
	  
	  #@filter_id = params[:id].nil?
	  
	  if params[:filter_id].nil?
	    flash[:error] = "no filter selected [x] close"
	    redirect_to :back
	  end
	  
	  redirect_to :back
	  
	  @cfilter_id = params[:filter_id]
	  @item_id = params[:id]
	  
	  #@circlerelationship = Circlerelationship.new(params[:id])
	  #@circlerelationship = Circlerelationship.new(:circle_id => @circle_id, :item_id => @item_id)
	  
  end
  
  
  def addfilter
		#for adding new filters from user account
  
		if params[:f_user_id].to_s != current_user.id.to_s
			flash[:error] = "error: filter add not permitted [x] close"
			redirect_to :back	
		else
				
			@newname = params[:name].strip.gsub("#","")
			@newnamefull = @newname.downcase.to_s
			
			#clean stop words
			lines = @newnamefull.to_s.gsub(","," ").gsub("  "," ")
			stop_words = %w{anus arse arsehole ass ass-hat ass-jabber ass-pirate assbag solidsignal assbandit assbanger fuckers motherfuckers assbite assclown asscock asscracker asses assface assfuck assfucker assgoblin asshat asshead asshole asshopper assjacker asslick asslicker assmonkey assmunch assmuncher assnigger asspirate assshit assshole asssucker asswad asswipe homosexual butt idiot jerk buttlicker bampot bastard beaner bitch bitchass bitches bitchtits bitchy blowjob blowjob bollocks bollox boner erection brotherfucker bullshit bumblefuck buttplug butt-pirate buttfucka buttfucker cameltoe carpetmuncher chinc chink choad chode clit clitface clitfuck clusterfuck cock cockass cockbite cockburger cockface cockfucker cockhead cockjockey cockknoker cockmaster cockmongler cockmongruel cockmonkey cockmuncher cocknose cocknugget cockshit cocksmith cocksmoker cocksniffer cocksucker cockwaffle coochie coochy coon cooter cracker cum cumbubble cumdumpster cumguzzler cumjockey cumslut cumtart cunnie cunnilingus cunt cuntass cuntface cunthole cuntlicker cuntrag cuntslut dago damn deggo dick dickbag dickbeaters dickface dickfuck dickfucker dickhead dickhole dickjuice dickmilk dickmonger dicks dickslap dicksucker dicksucking dickwad dickweasel dickweed dickwod dike dildo dipshit doochbag dookie douche douchebag douchewaffle dumass dumbasses dumbass dumbfuck dumbshit dumshit dyke fag fagbag fagfucker faggit faggots faggotcock fagtards fatass fellatio feltch flamers fuck fuckass fuckbag fuckboy fuckbrain fuckbutt fucked fucker fuckersucker fuckface fuckhead fuckhole fuckin fucking fucknut fucknutt fuckoff fucks fuckstick fucktard fucktart fuckup fuckwad fuckwit fuckwitt fudgepacker gay gayass gaybob gaydo gayfuck gayfuckist gaylord gaytard gaywad goddamn goddamnit gooch gook gringo guido handjob hardon heeb homo homodumbshit honkey humping jackass jap jerkoff jigaboo jizz junglebunny junglebunny kike kooch kootch kraut kunt kyke lameass lesbian lesbo lezzie mcfagget mick minge mothafucka mothafuckin motherfucker motherfucking muff muffdiver munging negro nigaboo nigga nigger niggerss nigletchild nutsack nutsack paki panooch pecker peckerhead penis penisfucker penispuffer piss pissed pissedoff pissflaps polesmoker pollock poon poonani poonany poontang porchmonkey porchmonkey prick punanny punta pussiess pussy pussylicking puto queef queer queerbait queerhole renob rimjob ruski retard sandnigger sandnigger schlong scrote shit shitass shitbag shitbagger shitbrains shitbreath shitcanned shitcunt shitdick shitface shitfaced shithead shithole shithouse shitspitter shitstain shitter shittiest shitting shitty shiz shiznit skank skeet skullfuck slut slutbag smeg snatch spic spick splooge spook suckass tard testicle thundercunt tit titfuck tits tittyfuck twat twatlips twatss twatwaffle unclefucker va-j-j vag vagina vjayjay wank wetback whore whorebag whoreface wop sex sexual sextoy genitals genitalia hussy ejaculate poop semen defecator jerk anus arsehole ass asshat assjabber ass-pirate assbag assbandit assbanger assbite assclown asscock asscracker asses assface assfuck assfucker assgoblin asshat asshead ass-hole asshopper assjacker asslick asslicker assmonkey assmunch assmuncher assnigger asspirate assshit asshole asssucker asswad asswipe homosexual butt idiot jerk buttlicker bampot bastard beaner bitch bitchass bitch-ass bitches bitchtits bitchy blowjob blow-job bollocks bollox boner erection brotherfucker bullshit bumblefuck buttplug butt-pirate buttfucka buttfucker cameltoe carpetmuncher chinc chink choad chode clit clitface clitfuck clusterfuck cock cockass cockbite cockburger cockface cockfucker cockhead cockjockey cockknoker cockmaster cockmongler cockmongruel cockmonkey cockmuncher cocknose cocknugget cockshit cocksmith cocksmoker cocksniffer cocksucker cockwaffle coochie coochy coon cooter cracker cum cumbubble cumdumpster cumguzzler cumjockey cumslut cumtart cunnie cunnilingus cunt cuntass cuntface cunthole cuntlicker cuntrag cuntslut dago damn deggo dick dickbag dickbeaters dickface dickfuck dickfucker dickhead dickhole dickjuice dickmilk dickmonger dicks dickslap dicksucker dicksucking dickwad dickweasel dickweed dickwod dike dildo dipshit doochbag dookie douche douche douchebag douchewaffle dumass dumbass dumb-ass dumbfuck dumbshit dumshit dyke fag fagbag fagfucker faggits faggot faggotcock fagtard fatass fellatio feltch flamer fucks fuckass fuckbag fuckboy fuckbrain fuckbutt fucked fucker fuckersucker fuckface fuckhead fuckhole fuckin fucking fucknut fucknutt fuckoff fucks fuckstick fucktard fucktart fuckup fuckwad fuckwit fuckwitt fudgepacker gays gayass gaybob gaydo gayfuck gayfuckist gaylord gaytard gaywad goddamn goddamnit gooch gook gringo guido handjob hardon heeb homo homodumbshit honkey humping jackass jap jerkoff jigaboo jizz junglebunny jungle-bunny kike kooch kootch kooter kraut kunt kyke lameass lesbian lesbo lezzie mcfagget mick minge muthafucka muthafuckin mutherfucker mutherfucking mothafucka mothafuckin motherfucker motherfucking muthafucka muthafuckin mutherfucker mutherfucking muff muffdiver munging negro nigaboo nigga niggas nigger niggers nigletchild nutsack nutsack paki panooch pecker peckerhead penis penisfucker penispuffer piss pissed pissedoff pissflaps polesmoker pollock poon poonani poonany poontang porchmonkey porch-monkey prick punanny punta pussie pussy pussylicking puto queef queer queerbait queerhole renob rimjob ruski retard sandnigger sand-nigger schlong scrote shit shitass shitbag shitbagger shitbrains shitbreath shitcanned shitcunt shitdick shitface shitfaced shithead shithole shithouse shitspitter shitstain shitter shittiest shitting shitty shiz shiznit skank skeet skullfuck slut slutbag smeg snatch spic spick splooge spook suckass tard testicle thundercunt tit titfuck tits tittyfuck twat twatlips twats twatwaffle unclefucker va-j-j vag vagina vjayjay wank wetback whore whorebag whoreface loser hoe hobag hobag hoebag hoebag cuntlicker cuntlicker ho-bag hoe-bag titty titties niger niggers niggas assholes nigggers asssholes assshole nigggas niggga nigggers pu$$y pusssy sandnigga sandnigga sand-nigga fart fagget piss pissy muthafucker muthafuck cumshot cumshot butthole junglebunnie cumlicker cumlicker cumface cuntwhore whorecunt fagot faget fagat fagget faggot faggat buttmunch}
		    @newnamefull = lines.split.reject{|str|stop_words.include?(str)}	
		    @newnamefull = @newnamefull.join(" ").to_s
			@newnamelength = @newnamefull.to_s.length
			

			if @newnamelength < 4
			  flash[:error] = "oops. filter name must be atleast four chars in length [x] close"
			  redirect_to :back				  
			elsif @newnamelength > 40
			  flash[:error] = "oops. circle filter may only be a maximum of fourty chars in length [x] close"
			  redirect_to :back
			else

				@filtercheck = Filter.find_by_sql(["SELECT id FROM filters WHERE name = ? AND user_id = ? LIMIT 1", @newnamefull, current_user.id])
				@checkfilcount = @filtercheck.count
				if @checkfilcount > 0
				  flash[:error] = "oops. you've already created a filter by that name [x] close"
				  redirect_to :back	
				else
				
				#do insert

					@privacy_setting = "Y"
					@current_datetime = DateTime.now
					@circleunsert = Filter.find_by_sql(["INSERT INTO filters (name, user_id, public, notify, created_at, updated_at) VALUES (?,?,'Y','Y',?,?)", @newnamefull, current_user.id.to_s, @current_datetime, @current_datetime])
					#@filternewsad = Filter.new(:user_id => current_user.id, :name => @newnamefull, :public => @privacy_setting, :notify => @privacy_setting)  
					#@filternewsad.save	
					@quote_char = '"'
					
					#if @filternewsad.save
						flash[:success] = "congrats, filter " + @quote_char + @newnamefull + @quote_char + " created [x] close"
					#else
					#	flash[:error] = "oops, error"
					#end
					redirect_to :back
								

				end
			end
		end
  
  
  end
  
  
  def editfilter
		
		if params[:filter_id].nil? || params[:f_user_id].nil?
			flash[:error] = "error: filter not updated [x] close"
			redirect_to :back	
		else
			if params[:f_user_id].to_s != current_user.id.to_s
				flash[:error] = "error: filter update not permitted [x] close"
				redirect_to :back	
			else
			
					#do update
					@newname = params[:name].strip.gsub("#","")
					@newnamefull = @newname.downcase.to_s

					#clean stop words
					lines = @newnamefull.to_s.gsub(","," ").gsub("  "," ")
					stop_words = %w{anus arse arsehole ass ass-hat ass-jabber ass-pirate solidsignal assbag assbandit assbanger fuckers motherfuckers assbite assclown asscock asscracker asses assface assfuck assfucker assgoblin asshat asshead asshole asshopper assjacker asslick asslicker assmonkey assmunch assmuncher assnigger asspirate assshit assshole asssucker asswad asswipe homosexual butt idiot jerk buttlicker bampot bastard beaner bitch bitchass bitches bitchtits bitchy blowjob blowjob bollocks bollox boner erection brotherfucker bullshit bumblefuck buttplug butt-pirate buttfucka buttfucker cameltoe carpetmuncher chinc chink choad chode clit clitface clitfuck clusterfuck cock cockass cockbite cockburger cockface cockfucker cockhead cockjockey cockknoker cockmaster cockmongler cockmongruel cockmonkey cockmuncher cocknose cocknugget cockshit cocksmith cocksmoker cocksniffer cocksucker cockwaffle coochie coochy coon cooter cracker cum cumbubble cumdumpster cumguzzler cumjockey cumslut cumtart cunnie cunnilingus cunt cuntass cuntface cunthole cuntlicker cuntrag cuntslut dago damn deggo dick dickbag dickbeaters dickface dickfuck dickfucker dickhead dickhole dickjuice dickmilk dickmonger dicks dickslap dicksucker dicksucking dickwad dickweasel dickweed dickwod dike dildo dipshit doochbag dookie douche douchebag douchewaffle dumass dumbasses dumbass dumbfuck dumbshit dumshit dyke fag fagbag fagfucker faggit faggots faggotcock fagtards fatass fellatio feltch flamers fuck fuckass fuckbag fuckboy fuckbrain fuckbutt fucked fucker fuckersucker fuckface fuckhead fuckhole fuckin fucking fucknut fucknutt fuckoff fucks fuckstick fucktard fucktart fuckup fuckwad fuckwit fuckwitt fudgepacker gay gayass gaybob gaydo gayfuck gayfuckist gaylord gaytard gaywad goddamn goddamnit gooch gook gringo guido handjob hardon heeb homo homodumbshit honkey humping jackass jap jerkoff jigaboo jizz junglebunny junglebunny kike kooch kootch kraut kunt kyke lameass lesbian lesbo lezzie mcfagget mick minge mothafucka mothafuckin motherfucker motherfucking muff muffdiver munging negro nigaboo nigga nigger niggerss nigletchild nutsack nutsack paki panooch pecker peckerhead penis penisfucker penispuffer piss pissed pissedoff pissflaps polesmoker pollock poon poonani poonany poontang porchmonkey porchmonkey prick punanny punta pussiess pussy pussylicking puto queef queer queerbait queerhole renob rimjob ruski retard sandnigger sandnigger schlong scrote shit shitass shitbag shitbagger shitbrains shitbreath shitcanned shitcunt shitdick shitface shitfaced shithead shithole shithouse shitspitter shitstain shitter shittiest shitting shitty shiz shiznit skank skeet skullfuck slut slutbag smeg snatch spic spick splooge spook suckass tard testicle thundercunt tit titfuck tits tittyfuck twat twatlips twatss twatwaffle unclefucker va-j-j vag vagina vjayjay wank wetback whore whorebag whoreface wop sex sexual sextoy genitals genitalia hussy ejaculate poop semen defecator jerk anus arsehole ass asshat assjabber ass-pirate assbag assbandit assbanger assbite assclown asscock asscracker asses assface assfuck assfucker assgoblin asshat asshead ass-hole asshopper assjacker asslick asslicker assmonkey assmunch assmuncher assnigger asspirate assshit asshole asssucker asswad asswipe homosexual butt idiot jerk buttlicker bampot bastard beaner bitch bitchass bitch-ass bitches bitchtits bitchy blowjob blow-job bollocks bollox boner erection brotherfucker bullshit bumblefuck buttplug butt-pirate buttfucka buttfucker cameltoe carpetmuncher chinc chink choad chode clit clitface clitfuck clusterfuck cock cockass cockbite cockburger cockface cockfucker cockhead cockjockey cockknoker cockmaster cockmongler cockmongruel cockmonkey cockmuncher cocknose cocknugget cockshit cocksmith cocksmoker cocksniffer cocksucker cockwaffle coochie coochy coon cooter cracker cum cumbubble cumdumpster cumguzzler cumjockey cumslut cumtart cunnie cunnilingus cunt cuntass cuntface cunthole cuntlicker cuntrag cuntslut dago damn deggo dick dickbag dickbeaters dickface dickfuck dickfucker dickhead dickhole dickjuice dickmilk dickmonger dicks dickslap dicksucker dicksucking dickwad dickweasel dickweed dickwod dike dildo dipshit doochbag dookie douche douche douchebag douchewaffle dumass dumbass dumb-ass dumbfuck dumbshit dumshit dyke fag fagbag fagfucker faggits faggot faggotcock fagtard fatass fellatio feltch flamer fucks fuckass fuckbag fuckboy fuckbrain fuckbutt fucked fucker fuckersucker fuckface fuckhead fuckhole fuckin fucking fucknut fucknutt fuckoff fucks fuckstick fucktard fucktart fuckup fuckwad fuckwit fuckwitt fudgepacker gays gayass gaybob gaydo gayfuck gayfuckist gaylord gaytard gaywad goddamn goddamnit gooch gook gringo guido handjob hardon heeb homo homodumbshit honkey humping jackass jap jerkoff jigaboo jizz junglebunny jungle-bunny kike kooch kootch kooter kraut kunt kyke lameass lesbian lesbo lezzie mcfagget mick minge muthafucka muthafuckin mutherfucker mutherfucking mothafucka mothafuckin motherfucker motherfucking muthafucka muthafuckin mutherfucker mutherfucking muff muffdiver munging negro nigaboo nigga niggas nigger niggers nigletchild nutsack nutsack paki panooch pecker peckerhead penis penisfucker penispuffer piss pissed pissedoff pissflaps polesmoker pollock poon poonani poonany poontang porchmonkey porch-monkey prick punanny punta pussie pussy pussylicking puto queef queer queerbait queerhole renob rimjob ruski retard sandnigger sand-nigger schlong scrote shit shitass shitbag shitbagger shitbrains shitbreath shitcanned shitcunt shitdick shitface shitfaced shithead shithole shithouse shitspitter shitstain shitter shittiest shitting shitty shiz shiznit skank skeet skullfuck slut slutbag smeg snatch spic spick splooge spook suckass tard testicle thundercunt tit titfuck tits tittyfuck twat twatlips twats twatwaffle unclefucker va-j-j vag vagina vjayjay wank wetback whore whorebag whoreface loser hoe hobag hobag hoebag hoebag cuntlicker cuntlicker ho-bag hoe-bag titty titties niger niggers niggas assholes nigggers asssholes assshole nigggas niggga nigggers pu$$y pusssy sandnigga sandnigga sand-nigga fart fagget piss pissy muthafucker muthafuck cumshot cumshot butthole junglebunnie cumlicker cumlicker cumface cuntwhore whorecunt fagot faget fagat fagget faggot faggat buttmunch}
					@newnamefull = lines.split.reject{|str|stop_words.include?(str)}	
					@newnamefull = @newnamefull.join(" ").to_s
					@newnamelength = @newnamefull.to_s.length
					
				  
					if @newnamelength < 4
					  flash[:error] = "oops. filter name must be atleast four chars in length [x] close"
					  redirect_to :back				  
					elsif @newnamelength > 40
					  flash[:error] = "oops. filter name may only be a maximum of fourty chars in length [x] close"
					  redirect_to :back
					else

						@circlecheck = Filter.find_by_sql(["SELECT id FROM filters WHERE name = ? AND user_id = ? AND id <> ? LIMIT 1", @newnamefull, current_user.id, params[:filter_id]])
						@checkcircount = @circlecheck.count
						if @checkcircount > 0
						  flash[:error] = "oops. you've already created a circle by that name."
						  redirect_to :back	
						else
												
							if not params[:public].nil? && params[:public] = "Y"
								@privacy_setting = "N"
							else
								@privacy_setting = "Y"
							end

							@filterupdate = Filter.find_by_sql(["UPDATE filters SET public = ?, name = ? WHERE id = ?", @privacy_setting, @newnamefull, params[:filter_id]])
							@quote_char = '"'
							flash[:success] = "filter " + @quote_char + @newnamefull + @quote_char + " updated [x] close"
							redirect_to :back	
					
						end			  
				 
				  end
			end	
		end
    
  end
  
  def editfilteruser
	flash[:success] = "facckeed "
  end 
  

  def destroy
    @filter.destroy
    #redirect_back_or root_path
    redirect_to :back
  end
  
  def makepublic
    @filter.public = "Y"
    flash[:success] = "Filter public!"
    redirect_to :back
  end
  
  def makeprivate
    @filter.public = "N"
    flash[:success] = "Filter private!"
    redirect_to :back
  end

  private

	def authorized_user
	  @filter = current_user.filters.find(params[:id])
	rescue
	  redirect_to root_path
	end
end
