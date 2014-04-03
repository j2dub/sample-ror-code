class SettingsController < ApplicationController

  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  
 


  
  def profile
    #@title = "profile"
    @title = "profile settings - " + current_user.name
    #canonical_url(profile_url)
      if signed_in?
		 @item = Item.new
	  end
	  
	  @firstname = current_user.first_name
	  @lastname = current_user.last_name
	  @website =  current_user.website
	  @emailaddress = current_user.email
	  @gender = current_user.gender
	  @phone = current_user.phone

	  if current_user.gender.empty? || current_user.gender.nil? || current_user.gender == " "
		@gender = ""
		@gendermode = "-"
		@gendermode_N = "false"
	  elsif current_user.gender == "N" 
		@gender ="prefer not to say"
		@gendermode = "N"
		@gendermode_N = "true"
	  elsif current_user.gender == "M"
		@gender = "male"
		@gendermode = "M"
		@gendermode_M = "true"
	  else	
		@gender = "female"
		@gendermode = "F"
		@gendermode_F = "true"
	  end
	  
	  @user = current_user
	  
	  

  end
  
  
  def updateprofile
		if signed_in?
		
			@user = current_user
			@user_id = current_user.id
			
			#first 3 have validation built in
			new_name = params[:name].gsub(/[^0-9a-z_]/i, '').strip.to_s
			new_firstname = params[:first_name].gsub(/[^a-z]/i,'').strip.to_s
			new_lastname = params[:last_name].gsub(/[^a-z]/i,'').strip.to_s
			
			
			#grab params for username bad name check (profain)
			@new_username = params[:name].to_s.gsub(" ","").downcase.strip
				
			#clean stop words
			lines = @new_username.to_s.gsub(","," ").gsub("  "," ")
			stop_words = %w{forsale forsalephoto sale salephoto for_sale for_sale_photo sale_photo _forsalephoto forsalephoto_ forsale_photo for_salephoto forsalefoto _forsale forsale_ facebook twitter pinterest stumbleupon tumblr youtube goolge yahoo myspace anus arse arsehole ass asshat assjabber asspirate assbag assbandit assbanger fuckers motherfuckers assbite assclown asscock asscracker asses assface assfuck assfucker assgoblin asshat asshead asshole asshopper assjacker asslick asslicker assmonkey assmunch assmuncher assnigger asspirate assshit assshole asssucker test testaccount newuser temporary temp solidsignal solid_signal hacker account master select insert delete update password group api beta blog demo forum forums iphone mobile secure svn weblog welcome search users items filters circles settings pings replies following followers follows help circlerelationships application locations zipcodes zipcode relationships sessions www drop table kill death script git casino nude porn viagra webcam sex topless asswad asswipe homosexual butt idiot jerk buttlicker bampot bastard beaner bitch bitchass bitches bitchtits bitchy blowjob blowjob bollocks bollox boner erection brotherfucker bullshit bumblefuck buttplug butt-pirate buttfucka buttfucker cameltoe carpetmuncher chinc chink choad chode clit clitface clitfuck clusterfuck cock cockass cockbite cockburger cockface cockfucker cockhead cockjockey cockknoker cockmaster cockmongler cockmongruel cockmonkey cockmuncher cocknose cocknugget cockshit cocksmith cocksmoker cocksniffer cocksucker cockwaffle coochie coochy coon cooter cracker cum cumbubble cumdumpster cumguzzler cumjockey cumslut cumtart cunnie cunnilingus cunt cuntass cuntface cunthole cuntlicker cuntrag cuntslut dago damn deggo dick dickbag dickbeaters dickface dickfuck dickfucker dickhead dickhole dickjuice dickmilk dickmonger dicks dickslap dicksucker dicksucking dickwad dickweasel dickweed dickwod dike dildo dipshit doochbag dookie douche douchebag douchewaffle dumass dumbasses dumbass dumbfuck dumbshit dumshit dyke fag fagbag fagfucker faggit faggots faggotcock fagtards fatass fellatio feltch flamers fuck fuckass fuckbag fuckboy fuckbrain fuckbutt fucked fucker fuckersucker fuckface fuckhead fuckhole fuckin fucking fucknut fucknutt fuckoff fucks fuckstick fucktard fucktart fuckup fuckwad fuckwit fuckwitt fudgepacker gay gayass gaybob gaydo gayfuck gayfuckist gaylord gaytard gaywad goddamn goddamnit gooch gook gringo guido handjob hardon heeb homo homodumbshit honkey humping jackass jap jerkoff jigaboo jizz junglebunny junglebunny kike kooch kootch kraut kunt kyke lameass lesbian lesbo lezzie mcfagget mick minge mothafucka mothafuckin motherfucker motherfucking muff muffdiver munging negro nigaboo nigga nigger niggerss nigletchild nutsack nutsack paki panooch pecker peckerhead penis penisfucker penispuffer piss pissed pissedoff pissflaps polesmoker pollock poon poonani poonany poontang porchmonkey porchmonkey prick punanny punta pussiess pussy pussylicking puto queef queer queerbait queerhole renob rimjob ruski retard sandnigger sandnigger schlong scrote shit shitass shitbag shitbagger shitbrains shitbreath shitcanned shitcunt shitdick shitface shitfaced shithead shithole shithouse shitspitter shitstain shitter shittiest shitting shitty shiz shiznit skank skeet skullfuck slut slutbag smeg snatch spic spick splooge spook suckass tard testicle thundercunt tit titfuck tits tittyfuck twat twatlips twatss twatwaffle unclefucker va-j-j vag vagina vjayjay wank wetback whore whorebag whoreface wop sex sexual sextoy genitals genitalia hussy ejaculate poop semen defecator jerk anus arsehole ass asshat assjabber ass-pirate assbag assbandit assbanger assbite assclown asscock asscracker asses assface assfuck assfucker assgoblin asshat asshead ass-hole asshopper assjacker asslick asslicker assmonkey assmunch assmuncher assnigger asspirate assshit asshole asssucker asswad asswipe homosexual butt idiot jerk buttlicker bampot bastard beaner bitch bitchass bitch-ass bitches bitchtits bitchy blowjob blow-job bollocks bollox boner erection brotherfucker bullshit bumblefuck buttplug butt-pirate buttfucka buttfucker cameltoe carpetmuncher chinc chink choad chode clit clitface clitfuck clusterfuck cock cockass cockbite cockburger cockface cockfucker cockhead cockjockey cockknoker cockmaster cockmongler cockmongruel cockmonkey cockmuncher cocknose cocknugget cockshit cocksmith cocksmoker cocksniffer cocksucker cockwaffle coochie coochy coon cooter cracker cum cumbubble cumdumpster cumguzzler cumjockey cumslut cumtart cunnie cunnilingus cunt cuntass cuntface cunthole cuntlicker cuntrag cuntslut dago damn deggo dick dickbag dickbeaters dickface dickfuck dickfucker dickhead dickhole dickjuice dickmilk dickmonger dicks dickslap dicksucker dicksucking dickwad dickweasel dickweed dickwod dike dildo dipshit doochbag dookie douche douche douchebag douchewaffle dumass dumbass dumb-ass dumbfuck dumbshit dumshit dyke fag fagbag fagfucker faggits faggot faggotcock fagtard fatass fellatio feltch flamer fucks fuckass fuckbag fuckboy fuckbrain fuckbutt fucked fucker fuckersucker fuckface fuckhead fuckhole fuckin fucking fucknut fucknutt fuckoff fucks fuckstick fucktard fucktart fuckup fuckwad fuckwit fuckwitt fudgepacker gays gayass gaybob gaydo gayfuck gayfuckist gaylord gaytard gaywad goddamn goddamnit gooch gook gringo guido handjob hardon heeb homo homodumbshit honkey humping jackass jap jerkoff jigaboo jizz junglebunny jungle-bunny kike kooch kootch kooter kraut kunt kyke lameass lesbian lesbo lezzie mcfagget mick minge muthafucka muthafuckin mutherfucker mutherfucking mothafucka mothafuckin motherfucker motherfucking muthafucka muthafuckin mutherfucker mutherfucking muff muffdiver munging negro nigaboo nigga niggas nigger niggers nigletchild nutsack nutsack paki panooch pecker peckerhead penis penisfucker penispuffer piss pissed pissedoff pissflaps polesmoker pollock poon poonani poonany poontang porchmonkey porch-monkey prick punanny punta pussie pussy pussylicking puto queef queer queerbait queerhole renob rimjob ruski retard sandnigger sand-nigger schlong scrote shit shitass shitbag shitbagger shitbrains shitbreath shitcanned shitcunt shitdick shitface shitfaced shithead shithole shithouse shitspitter shitstain shitter shittiest shitting shitty shiz shiznit skank skeet skullfuck slut slutbag smeg snatch spic spick splooge spook suckass tard testicle thundercunt tit titfuck tits tittyfuck twat twatlips twats twatwaffle unclefucker va-j-j vag vagina vjayjay wank wetback whore whorebag whoreface loser hoe hobag hobag hoebag hoebag cuntlicker cuntlicker ho-bag hoe-bag titty titties niger niggers niggas assholes nigggers asssholes assshole nigggas niggga nigggers pu$$y pusssy sandnigga sandnigga sand-nigga fart fagget piss pissy muthafucker muthafuck cumshot cumshot butthole junglebunnie cumlicker cumlicker cumface cuntwhore whorecunt fagot faget fagat fagget faggot faggat buttmunch}
			@new_username = lines.split.reject{|str|stop_words.include?(str)}	
			@new_username = @new_username.to_s.gsub("[]","")	
			@new_username_length = @new_username.gsub("]","").gsub("[","").length.to_i - 2

		
			unless @new_username.empty? 	
			
				if @new_username_length < 4 || @new_username_length > 50
					userlength = "failed"
					#flash[:error] = "oops, the username must be atleast four, but not more than fifty characters in length. [X] close"
					#redirect_to :back	
				else
			
					@usercheck = User.find(:all, :conditions => ["name = ? AND id <> ?", new_name, @user_id])
					if @usercheck.empty?
						@user.update_attribute(:name, new_name)
						@user.update_attribute(:updated_at, Time.now)
						sign_in @user
					else
						usercheck = "failed"
					end
					
				end
				
			else
				usercheck = "failed"
			end	
			
			
			@user.update_attribute(:first_name, new_firstname)
			@user.update_attribute(:last_name, new_lastname)
			@user.update_attribute(:updated_at, Time.now)
			
						
			#do validation on url
			new_website = params[:website].gsub(",",".").strip.to_s
			new_website_length = new_website.mb_chars.length.to_i
			length1 = new_website.length-6
			length2 = new_website.length
			
			if not new_website.empty?
				domext = new_website[length1, length2].gsub(/[^a-z.]/i, '').include? "." 
			end
			
			if usercheck == "failed"
				flash[:error] = "oops, the username entered is not available. [X] close"
				redirect_to :back	
			elsif userlength == "failed"		
				flash[:error] = "oops, the username must be atleast four, but not more than fifty characters in length. [X] close"	
				redirect_to :back		
			elsif new_website_length == 0				
				@user.update_attribute(:website, new_website)
				@user.update_attribute(:updated_at, Time.now)
				sign_in @user
				flash[:success] = "success, your profile has been saved. [X] close"
				redirect_to :back			
			elsif domext == true && (new_website[0, 7].to_s == "http://" || new_website[0, 8].to_s == "https://")
				@user.update_attribute(:website, new_website)
				@user.update_attribute(:updated_at, Time.now)
				sign_in @user
				flash[:success] = "success, your profile has been saved. [X] close"
				redirect_to :back	
			else
				@poop = "yucku"
				flash[:error] = "oops, your website must be in valid url format. [X] close"
				redirect_to :back				
			end
			
			#this validation is complete
			#@user.update_attributes(params[:user])
			#@user.skip_validation_for :email, :password
			


		end
  end
  
 
  
  def updateprivate
		if signed_in?
		
			@user = current_user
			@user_id = current_user.id
			#usertxtsms = current_user.name
		
			
			new_email = params[:email].strip
			new_phone = params[:phone].strip.gsub('-','')
			new_phone_length = new_phone.mb_chars.length.to_i
			new_gender = params[:gender].strip
			
													
			
			
			#gender ok to update
			@user.update_attribute(:gender, new_gender)
			
			
			if new_email.nil? || new_email.empty?
				flash[:error] = "oops, all accounts require an email address. [X] close"
				redirect_to :back			
			else
				if not is_a_valid_email?(new_email)	
				else
				
					@usercheck = User.find(:all, :conditions => ["email = ? AND id <> ?", new_email, @user_id])
					if @usercheck.empty?	
					
							if is_numeric?(new_phone) && new_phone_length == 10
								asd = "456:"
								ph1 = new_phone.slice(0..2)
								ph2 = new_phone.slice(3..5)
								ph3 = new_phone.slice(6..9)
								new_phone = ph1 + "-" + ph2 + "-" + ph3
								@user.update_attribute(:phone, new_phone) 
								@user.update_attribute(:email, new_email)	
								sign_in @user
								flash[:success] = "success, your information has been saved. [X] close"
								redirect_to :back
							elsif new_phone_length == 0
								@user.update_attribute(:phone, new_phone)
								@user.update_attribute(:email, new_email)
								sign_in @user
								flash[:success] = "success, your information has been saved. [X] close"
								redirect_to :back
							else
								flash[:error] = "phone number must be a valid format. [X] close"
								redirect_to :back
							end
						
					else
							flash[:error] = "oops, that email belongs to another user. [X] close"
							redirect_to :back
					end	
						
				end
				
			end

			#this validation is complete


		end
  end
  
  
  def account
	@title = "account settings - " + current_user.name
      if signed_in?
		 @item = Item.new
	  end	
		@user = current_user
		@user_id = current_user.id	 
		@name_temp = current_user.name	
		@email_temp = current_user.email	
  end
  
  
  def emails
  
	@title = "email addresses - " + current_user.name
      if signed_in?
		 @item = Item.new
	  end	
	  
	  @user = current_user
	  @user_id = current_user.id	  
	  @verifyemail = params[:e].to_s
	  @verifycode = params[:vid].to_s
	  
	  
	  if not @verifycode.empty?
	  # process email verification
	  
		@emailcheck = Email.find(:all, :conditions => ["user_id = ? AND verify_code = ?", current_user.id, @verifycode])
	  
		if not @emailcheck.nil?
		
	  			@emailverify = Email.find_by_sql(["UPDATE emails SET (verifed) = (?) WHERE verify_code = ? AND user_id = ?", 'Y', @verifycode, current_user.id])
				flash[:success] = "success, email address verified. [X] close"
				redirect_to settings_emails_path
		end
		
	  end
	  
		@user_email = current_user.email
		
		@emails = Email.find(:all, :conditions => ["user_id = ? AND deleted = ?", current_user.id, "N"])
		@emailscount =  @emails.count
		
  end
  
  
  def addemail
 
	if signed_in?
	
			@user = current_user
			@user_id = current_user.id
			user_name = current_user.name
			@user_email_default = current_user.email.to_s
			
		
			new_email = params[:emailnew].to_s.gsub(" ","").downcase.strip  
			
			if new_email.nil? || new_email.empty?
				flash[:error] = "oops, must enter an email address. [X] close" + new_email.to_s
				redirect_to :back			
			else
			
				if not is_a_valid_email?(new_email)		
					flash[:error] = "oops. email must be a valid format. [X] close" + new_email.to_s
					redirect_to :back
				else
			
					#check to make sure new email isnt the default
					if new_email.to_s != @user_email_default
			
						#get random verify code
						def random_string(length)  
							rand(36**length).to_s(36)  
						end  
						@shortcode = random_string 9
						verifycode = @shortcode.to_s			
				
						@emailcheck = Email.find(:first, :conditions => ["email = ? AND user_id = ? AND deleted = ?", new_email, @user_id, 'N'])    
						if @emailcheck.nil?
						
							@new_email = new_email
							emailadd = @new_email.to_s
							#insert into table
							@emailinsert = Email.find_by_sql(["INSERT INTO emails (user_id, email, verify_code, created_at, updated_at) VALUES (?,?,?,?,?)", @user_id, @new_email, @shortcode, Time.now, Time.now])
							
							time = Time.new
							rooturl  = "#{request.protocol}#{request.host_with_port}"
							
							#send verification email
							smtp = { :address => 'mail.forsalephoto.com', :port => 26, :domain => 'forsalephoto.com', :user_name => 'notification@forsalephoto.com', :password => '!7guRjMx34', :enable_starttls_auto => true, :openssl_verify_mode => 'none' }
								Mail.defaults { delivery_method :smtp, smtp }    
								mail = Mail.new do
								from    'forsalephoto <notification@forsalephoto.com>'
								to      emailadd
								subject 'forsalephoto - email address verification'
								
								 html_part do
									content_type 'text/html; charset=UTF-8'
									#body 'Hey '+user_name+',<br/><br/>We recently process a request to add this email address to your account. <br/> Please click the link below to verfiy this email address.<br/><br/>Verification link: <a href=http://localhost:3000/settings/emails/?vid='+verifycode+'>http://localhost:3000/settings/emails/?vid='+verifycode+'</a><br/><br/>Thank you for using our service!<br/><br/><br/><b><font size=3>forsalephoto</font></b><br/><i>your place to post and share photos of items for sale</i><br/><a href=http://forsalephoto.com/>forsalephoto.com</a><br/><br/>'
								    #attachments.inline['logo-center-99.png'] = File.read('assets/logo-center-99.png')
								    
									#attachments.inline['logo'] = {
									#								:data => File.read("#{Rails.root.to_s + '/app/assets/images/logo-center-99.png'}"),
									#								:content_type => "image/png",
									#							#	:encoding => "base64"
									#							  }						
																  
									#attachment :content_type => "image/png",  :body => File.read("#{Rails.root}/app/assets/images/logo-center-99.png")
									#attachment :content_type => "image/png",  :body => File.read("#{Rails.root.to_s + '/app/assets/images/logo-center-99.png'}")
								    
								    body '<table cellspacing="0" cellpadding="0" border="0" width="100%">
											<tr>
												<td bgcolor=#cccccc height="90" valign="middle" align="center">
														
														<a href="http://forsalephoto.com"><img src=http://asset-cache-01.forsalephoto.com/logo-center-99.png  align="center" border="0" style="margin-top:7px;margin-right:4px;"></a>
					
												</td>
											</tr>
											<tr>
												<td bgcolor="#f4f4f4" height="120">
												
													<table border="0" align="center" cellpadding="0" cellspacing="0" width="50%">
														<tbody>
															<tr>
																<td align="center" valign="top" style="color:#808080;font-family:Trebuchet MS;font-size:20px;line-height:100%;letter-spacing:-1px;text-align:center">																
																	<h1 style="display:block;font-family:Trebuchet MS;font-style:normal;line-height:115%;margin-top:10px;margin-right:0;margin-bottom:0;margin-left:0;font-size:24px;letter-spacing:-1px;text-align:center;font-weight:500;color:#202020;text-decoration:none">'+user_name+', you have added an alternate email address.</h1>
																</td>
															</tr>
														</tbody>
													</table>												
												
												</td>
											</tr>
											<tr>
												<td bgcolor="#f4f4f4" height="150">
											
													<table align="center" border="0" cellpadding="10" cellspacing="0" width="50%" style="background-color:#fcfcfc;border:1px solid #dadada;border-radius:3px;border-collapse:separate">
														<tbody>
															<tr>
																<td style="color:#202020;font-family:Trebuchet MS;font-size:16px;font-weight:bold;line-height:150%;padding-top:20px;padding-bottom:20px;text-align:center">
																	<h2 style="display:block;font-family:Helvetica;font-style:normal;line-height:115%;margin-top:0;margin-right:0;margin-bottom:0;margin-left:0;font-size:24px;letter-spacing:-1px;text-align:center;font-weight:bold;color:#F15A29;text-decoration:none"><a href="" style="font-weight:bold;color:#F15A29;text-decoration:none"><span style="font-weight:bold;color:#F15A29;text-decoration:none">'+emailadd.to_s+'</span></a></h2>
																	<p style="color:#666;margin-top:15px;font-weight:500;font-family:Trebuchet MS;">[ click the button below to verify ]</p>
																</td>
															</tr>
														</tbody>
													</table>
											
												</td>
											</tr>
									
											<tr>
												<td bgcolor="#f4f4f4" height="180">
													<p align="center" style="margin-bottom:-30px;">
														<table border="0" cellpadding="15" cellspacing="0" style="background-color:#F15A29;border:1px solid #b74028;border-radius:3px" align="center">
															<tbody>
																<tr>
																	<td align="center" valign="middle" style="padding-left:45px;padding-right:45px;font-family:Helvetica;font-size:20px;font-weight:500;line-height:100%;letter-spacing:-.5px;text-align:center;text-decoration:none;color:#ffffff">
																		<a href="'+rooturl+'/settings/emails/?vid='+verifycode+'" title="verify your email address" style="font-family:Trebuchet MS;font-size:20px;font-weight:500;line-height:100%;letter-spacing:-.5px;text-align:center;text-decoration:none;color:#ffffff" target="_blank"><span style="font-family:Trebuchet MS;font-size:20px;font-weight:500;line-height:100%;letter-spacing:-.5px;text-align:center;text-decoration:none;color:#ffffff">verify email address</span></a>
																	</td>
																</tr>
															</tbody>
														</table>
													</p>
												</td>
											</tr>	
		
											<tr>
												<td bgcolor="#f4f4f4" height="200">											
											
											
														<table align="center" bgcolor="#f4f4f4"  border="0" cellpadding="0" cellspacing="0" >
		                                    	<tbody>
		 
		                                        <tr>
		                                        	<td align="center" valign="top" style="width:600px; border-top:1px solid #dadada;border-bottom:0px solid #dadada;padding-top:22px;padding-bottom:30px">
																	<p style="color:#666;margin-top:-12px;font-weight:500;font-family:Trebuchet MS;font-size:11px;">
																		<span style="font-size:9px;">&copy;'+time.year.to_s+'</span> forsalephoto intellectual property. all rights reserved.<a style="text-decoration:none;" href="http://forsalephoto.com/signin" ><span style="margin-left:240px;color:#666;"><b>login</b></span></a>
																		</p>
		                                            </td>
		                                        </tr>
		                                    </tbody>
		                                    </table>
											
											
												</td>											
											</tr>
											
											
										</table>'
								 
								 
								  end
								
								
								#body    'Hey'+username+'<br/>Your new for sale photo has been successfully uploaded.<br/>You can edit the tags and price of the item by by visiting this link: <a href=http://localhost:3000/items/'+imageid+'/edit>http://localhost:3000/items/'+imageid+'/edit</a><br/><br/>'
								end
								mail.deliver!							
							
							
							
							
							flash[:success] = "success, email address added. please verify. [X] close"
							redirect_to :back
					
						else
							
							flash[:error] = "oops, email address must be unique. [X] close"
							redirect_to :back							
									
						end  			
					
					

					
					else

						flash[:error] = "oops, email address must be unique. [X] close"
						redirect_to :back
					
					end
					
				end
				

				
			end
				
				#@item.tinyurl = @shortcode
				#@item.save  
  
	end
  
  end
  
  
  def dropemail
  
	if signed_in?
	
			@user = current_user
			@user_id = current_user.id
			@user_email_default = current_user.email.to_s  
			@verifyemail = params[:eid].to_i
  
			@emailcheck = Email.find(:first, :conditions => ["id = ? ", @verifyemail ]) 
			@emailreal = @emailcheck.email
			@emailuserid = @emailcheck.user_id
			
			if @user_id.to_s == @emailuserid.to_s
			
				#set email to deleted
				@emaildelete= Email.find_by_sql(["UPDATE emails SET (deleted, deleted_at) = (?,?) WHERE id = ?", 'Y', Time.now, @verifyemail])
				
				
			
				flash[:success] = "success, email address removed. [X] close"
				redirect_to :back			
			else
			
				flash[:error] = "oops, something went wrong. [X] close"
				redirect_to :back						
			
			end
	end	
			
  end 
  
  
  def circles
    @title = "manage circles - " + current_user.name
    #@circles = Circle.find(params[:id])
    @circles = Circle.find(:all, :conditions => ["user_id = ?", current_user.id])
 
    
      if signed_in?
		 @item = Item.new
		 @circle = Circle.new
		 
		 
		  #@circles = Circle.find(:all, :conditions => ["user_id = ?", current_user.id])
		  #@circlerelationships = Circlerelationship.find(:all, :conditions => ["circle_id = ?", @circles.id])
		 
	  end  
  end
  
  
  def filters
  
     @title = current_user.name + " - manage filters "
     @filters = Filter.find(:all, :conditions => ["user_id = ?", current_user.id])
     
      if signed_in?
		 @item = Item.new
		 @filter = Filter.new 
	  end
	    
  end
  
  
  def locations
     @title = "manage locations - " + current_user.name
      if signed_in?
		 @item = Item.new
		 @location = Location.new 
	  end 
	  @user = current_user
	  @user_id = current_user.id 
	  
		@locations = Location.find_by_sql(["SELECT locations.*, zipcodes.citymixedcase, zipcodes.state " +
			"FROM locations " +
			"INNER JOIN zipcodes ON locations.zipcode_id = zipcodes.zipcode " +
			"WHERE locations.user_id = ? AND locations.deleted = ? " +
			"ORDER BY locations.created_at DESC ", current_user.id.to_s, "N"])
	  
		#@locations = Location.find(:all, :conditions => ["user_id = ? AND deleted = ?", current_user.id.to_s, "N"])
		@locationscount = @locations.count
	  
	  
  end
  
  
  def addlocation
 
	if signed_in?
	
			@user = current_user
			@user_id = current_user.id
			user_name = current_user.name
			
			@new_zipcode = params[:zipcode].to_s.gsub(" ","").strip  
			
			@location = Location.find_by_sql(["SELECT id FROM locations " +
			"WHERE zipcode_id = ? AND user_id = ? AND deleted = ?" +
			"LIMIT 1 ", @new_zipcode, @user_id.to_s, 'N']) 
			
			
			
			if @location.empty?
			
			
				#@zipcodes = Zipcode.find(:all, :conditions => ["zipcode = ?", new_zipcode])
				@zipcode = Zipcode.find_by_sql(["SELECT id FROM zipcodes " +
				"WHERE zipcode = ? " +
				"LIMIT 1 ", @new_zipcode.to_s]) 
			
				unless @zipcode.empty?
					#add location
					@locationinsert = Location.find_by_sql(["INSERT INTO locations (user_id, zipcode_id, created_at, updated_at) VALUES (?,?,?,?)", @user_id, @new_zipcode, Time.now, Time.now])
				
					flash[:success] = "success, location added to your account. [x] close"
					redirect_to :back
					
				else
					flash[:error] = "oops, zip entered does not appear to be valid. [x] close"
					redirect_to :back
				end
			else	
					flash[:error] = "oops, that location is already on your account. [x] close"
					redirect_to :back				
			end
			
	end
  end  
  

  def droplocation
  
	if signed_in?
  
			@user = current_user
			@user_id = current_user.id.to_s
			
			#@user_email_default = current_user.email.to_s  
			@locationid = params[:lid].to_i
  
			#@locationcheck = Location.find(:first, :conditions => ["id = ? AND user_id = ?", @locationid, @user_id ]) 
			@location = Location.find_by_sql(["SELECT id FROM locations " +
			"WHERE id = ? AND user_id = ? " +
			"LIMIT 1 ", @locationid, @user_id]) 				
			
			
		#	@emailreal = @emailcheck.email
		#	@emailuserid = @emailcheck.user_id
			
			#if @user_id.to_s == @emailuserid.to_s
			unless @location.empty?
				#set location to deleted
				@locationdelete = Location.find_by_sql(["UPDATE locations SET (deleted, deleted_at) = (?,?) WHERE id = ?", 'Y', Time.now, @locationid])
				
				flash[:success] = "success, location has been removed. [X] close"
				redirect_to :back			
			else
			
				flash[:error] = "oops, something went wrong. [X] close"
				redirect_to :back						
			
			end
			
	end	
			
  end   
  
  
def social
  
     @title = "manage social networks - " + current_user.name
      if signed_in?
		 @item = Item.new
	  end 
	  @user = current_user
	  @user_id = current_user.id 
	  
		@social = User.find_by_sql(["SELECT users.pr_twitter, users.pr_facebook, users.pr_googleplus " +
			"FROM users " +
		    "WHERE users.id = ? AND users.deleted = ? AND users.flagged = ? ", current_user.id.to_s, "N", "N"])
			
			unless @social.empty?
			
			  @pr_twitter = @user.pr_twitter
			  @pr_facebook = @user.pr_facebook
			  @pr_googleplus = @user.pr_googleplus
			
			end
	  
		#@locations = Location.find(:all, :conditions => ["user_id = ? AND deleted = ?", current_user.id.to_s, "N"])
	    #@locationscount =  @locations.count
	  
end

  
def updatesocial
	if signed_in?
	
		@user = current_user
		@user_id = current_user.id
		
		#first 3 have validation built in
		new_pr_twitter = params[:pr_twitter].gsub(",",".").gsub("@","").gsub("{","").gsub("}","").strip.downcase.to_s
		new_pr_twitter_length = new_pr_twitter.mb_chars.length.to_i
			pr_twitter_length1 = new_pr_twitter.length-7
			pr_twitter_length2 = new_pr_twitter.length		
			if not new_pr_twitter.empty?
				pr_twitter_domext = new_pr_twitter[pr_twitter_length1, pr_twitter_length2].gsub(/[^a-z.]/i, '').include? "." 
			end			
		
		new_pr_facebook = params[:pr_facebook].gsub(",",".").strip.downcase.to_s
		new_pr_facebook_length = new_pr_facebook.mb_chars.length.to_i
			pr_facebook_length1 = new_pr_facebook.length-7
			pr_facebook_length2 = new_pr_facebook.length
			if not new_pr_facebook.empty?
				pr_facebook_domext = new_pr_facebook[pr_facebook_length1, pr_facebook_length2].gsub(/[^a-z.]/i, '').include? "." 
			end								
		
		new_pr_googleplus = params[:pr_googleplus].gsub(",",".").gsub("@","").gsub("{","").gsub("}","").strip.downcase.to_s
		new_pr_googleplus_length = new_pr_googleplus.mb_chars.length.to_i
			pr_googleplus_length1 = new_pr_googleplus.length-7
			pr_googleplus_length2 = new_pr_googleplus.length	
			if not new_pr_googleplus.empty?
				pr_googleplus_domext = new_pr_googleplus[pr_googleplus_length1, pr_googleplus_length2].gsub(/[^a-z.]/i, '').include? "." 
			end				
			
		if new_pr_twitter_length == 0 && new_pr_facebook_length == 0 && new_pr_googleplus_length == 0
			@user.update_attribute(:pr_twitter, "")
			@user.update_attribute(:pr_facebook, "")
			@user.update_attribute(:pr_googleplus, "")
			@user.update_attribute(:updated_at, Time.now)
			sign_in @user
			flash[:success] = "your social settings have been saved. [X] close"
			redirect_to :back		
		else
		
		
			#if pr_twitter_domext == true && new_pr_twitter.to_s.include?("twitter.com") && (new_pr_twitter[0, 7].to_s == "http://" || new_pr_twitter[0, 8].to_s == "https://") 
			if new_pr_twitter_length > 0
				if new_pr_twitter.to_s.include?("twitter.com") 
						new_pr_twitter = new_pr_twitter.gsub("www.twitter.com","").gsub("ww.twitter.com","").gsub("w.twitter.com","").gsub("twitter.com","").gsub("https://","").gsub("http://","").gsub("/","")
						new_pr_twitter = "https://twitter.com/" + new_pr_twitter.to_s
				else
						new_pr_twitter = ""
				end
				@user.update_attribute(:pr_twitter, new_pr_twitter)
				@user.update_attribute(:updated_at, Time.now)
				sign_in @user
			elsif new_pr_twitter_length == 0
				new_pr_twitter = ""
				@user.update_attribute(:pr_twitter, new_pr_twitter)
				@user.update_attribute(:updated_at, Time.now)
				sign_in @user			
			end
	
			
			if new_pr_facebook_length > 0
				if new_pr_facebook.to_s.include?("facebook.com")
						new_pr_facebook = new_pr_facebook.gsub("www.facebook.com","").gsub("ww.facebook.com","").gsub("w.facebook.com","").gsub("facebook.com","").gsub("https://","").gsub("http://","")
						new_pr_facebook = "https://www.facebook.com" + new_pr_facebook.to_s
				else
						new_pr_facebook = ""
				end			
				@user.update_attribute(:pr_facebook, new_pr_facebook)
				@user.update_attribute(:updated_at, Time.now)
				sign_in @user
			elsif new_pr_facebook_length == 0
				new_pr_facebook = ""
				@user.update_attribute(:pr_facebook, new_pr_facebook)
				@user.update_attribute(:updated_at, Time.now)
				sign_in @user			
			end
	
			if new_pr_googleplus_length > 0
				if new_pr_googleplus.to_s.include?("plus.google.com") 
						new_pr_googleplus = new_pr_googleplus.gsub("plus.google.com","").gsub("www.google.com","").gsub("ww.google.com","").gsub("w.google.com","").gsub("google.com","").gsub("https://","").gsub("http://","").gsub("/posts","").gsub("/","")
						new_pr_googleplus = "https://plus.google.com/" + new_pr_googleplus.to_s	
				else
						new_pr_googleplus = ""
				end				
				@user.update_attribute(:pr_googleplus, new_pr_googleplus)
				@user.update_attribute(:updated_at, Time.now)
				sign_in @user	
			elsif new_pr_googleplus_length == 0
				@user.update_attribute(:pr_googleplus, new_pr_googleplus)
				@user.update_attribute(:updated_at, Time.now)
				sign_in @user			
			end			
		
			flash[:success] = "your social settings have been saved. [X] close"
			redirect_to :back	
			
		end 
		
	end
end

  
def stores
  
     @title = "manage online stores - " + current_user.name
      if signed_in?
		 @item = Item.new
	  end 
	  @user = current_user
	  @user_id = current_user.id 
	  
		@stores = User.find_by_sql(["SELECT users.pr_amazon, users.pr_ebay, users.pr_etsy, users.pr_bonanza, users.pr_other " +
			"FROM users " +
		    "WHERE users.id = ? AND users.deleted = ? AND users.flagged = ? ", current_user.id.to_s, "N", "N"])
			
			unless @stores.empty?
			
			  @pr_amazon = @user.pr_amazon
			  @pr_ebay = @user.pr_ebay
			  @pr_etsy = @user.pr_etsy
			  @pr_bonanza = @user.pr_bonanza
			  @pr_other = @user.pr_other
			
			end
	  
		#@locations = Location.find(:all, :conditions => ["user_id = ? AND deleted = ?", current_user.id.to_s, "N"])
	    #@locationscount =  @locations.count
	  
end  
  
  
def updatestores
	if signed_in?
	
		@user = current_user
		@user_id = current_user.id
		
		
		new_pr_amazon = params[:pr_amazon].gsub(",",".").gsub("@","").gsub("{","").gsub("}","").strip.downcase.to_s
		new_pr_amazon_length = new_pr_amazon.mb_chars.length.to_i
			pr_amazon_length1 = new_pr_amazon.length-7
			pr_amazon_length2 = new_pr_amazon.length		
			if not new_pr_amazon.empty?
				pr_amazon_domext = new_pr_amazon[pr_amazon_length1, pr_amazon_length2].gsub(/[^a-z.]/i, '').include? "." 
			end			

		new_pr_ebay = params[:pr_ebay].gsub(",",".").gsub("@","").gsub("{","").gsub("}","").strip.downcase.to_s
		new_pr_ebay_length = new_pr_ebay.mb_chars.length.to_i
			pr_ebay_length1 = new_pr_ebay.length-7
			pr_ebay_length2 = new_pr_ebay.length		
			if not new_pr_ebay.empty?
				pr_ebay_domext = new_pr_ebay[pr_ebay_length1, pr_ebay_length2].gsub(/[^a-z.]/i, '').include? "." 
			end	

		new_pr_etsy = params[:pr_etsy].gsub(",",".").gsub("@","").gsub("{","").gsub("}","").strip.downcase.to_s
		new_pr_etsy_length = new_pr_etsy.mb_chars.length.to_i
			pr_etsy_length1 = new_pr_etsy.length-7
			pr_etsy_length2 = new_pr_etsy.length		
			if not new_pr_etsy.empty?
				pr_etsy_domext = new_pr_etsy[pr_etsy_length1, pr_etsy_length2].gsub(/[^a-z.]/i, '').include? "." 
			end			
		
		new_pr_other = params[:pr_other].gsub(",",".").gsub("@","").gsub("{","").gsub("}","").strip.downcase.to_s
		new_pr_other_length = new_pr_other.mb_chars.length.to_i
			pr_other_length1 = new_pr_other.length-7
			pr_other_length2 = new_pr_other.length		
			if not new_pr_other.empty?
				pr_other_domext = new_pr_other[pr_other_length1, pr_other_length2].gsub(/[^a-z.]/i, '').include? "." 
			end			

		if new_pr_amazon_length == 0 && new_pr_ebay_length == 0 && new_pr_etsy_length == 0 && new_pr_other_length == 0
			@user.update_attribute(:pr_amazon, "")
			@user.update_attribute(:pr_ebay, "")
			@user.update_attribute(:pr_etsy, "")
			@user.update_attribute(:pr_other, "")
			@user.update_attribute(:updated_at, Time.now)
			sign_in @user
			flash[:success] = "your store settings have been saved. [X] close"
			redirect_to :back		
		else


			if new_pr_amazon_length > 0
				if new_pr_amazon.to_s.include?("amazon.com") 
						new_pr_amazon = new_pr_amazon.gsub("www.amazon.com","").gsub("ww.amazon.com","").gsub("w.amazon.com","").gsub("amazon.com","").gsub("https://","").gsub("http://","").gsub("b?me=","").gsub("/","")
						new_pr_amazon = "http://www.amazon.com/b?me=" + new_pr_amazon.to_s
				else
						new_pr_amazon = ""
				end
				@user.update_attribute(:pr_amazon, new_pr_amazon)
				@user.update_attribute(:updated_at, Time.now)
				sign_in @user
			elsif new_pr_amazon_length == 0
				new_pr_amazon = ""
				@user.update_attribute(:pr_amazon, new_pr_amazon)
				@user.update_attribute(:updated_at, Time.now)
				sign_in @user			
			end


			if new_pr_ebay_length > 0
				if new_pr_ebay.to_s.include?("ebay.com")
						new_pr_ebay = new_pr_ebay.gsub("www.ebay.com","").gsub("ww.ebay.com","").gsub("w.ebay.com","").gsub("ebay.com","").gsub("https://","").gsub("http://","").gsub("/usr/","").gsub("/","")
						new_pr_ebay = "http://www.ebay.com/usr/" + new_pr_ebay.to_s
				else
						new_pr_ebay = ""
				end			
				@user.update_attribute(:pr_ebay, new_pr_ebay)
				@user.update_attribute(:updated_at, Time.now)
				sign_in @user
			elsif new_pr_ebay_length == 0
				new_pr_ebay = ""
				@user.update_attribute(:pr_ebay, new_pr_ebay)
				@user.update_attribute(:updated_at, Time.now)
				sign_in @user			
			end

			if new_pr_etsy_length > 0
				if new_pr_etsy.to_s.include?("etsy.com")
						new_pr_etsy = new_pr_etsy.gsub("www.etsy.com","").gsub("ww.etsy.com","").gsub("w.etsy.com","").gsub("etsy.com","").gsub("https://","").gsub("http://","").gsub("/shop/","").gsub("/","")
						new_pr_etsy = "https://www.etsy.com/shop/" + new_pr_etsy.to_s
				else
						new_pr_etsy = ""
				end			
				@user.update_attribute(:pr_etsy, new_pr_etsy)
				@user.update_attribute(:updated_at, Time.now)
				sign_in @user
			elsif new_pr_etsy_length == 0
				new_pr_etsy = ""
				@user.update_attribute(:pr_etsy, new_pr_etsy)
				@user.update_attribute(:updated_at, Time.now)
				sign_in @user			
			end			
			

			if new_pr_other_length > 0
				if new_pr_other.to_s.include?("http://") || new_pr_other.to_s.include?("https://")
					if new_pr_other.to_s.include?(".com") || new_pr_other.to_s.include?(".net")	|| new_pr_other.to_s.include?(".co")
						#new_pr_other = new_pr_other.gsub("plus.google.com","").gsub("www.google.com","").gsub("ww.google.com","").gsub("w.google.com","").gsub("google.com","").gsub("https://","").gsub("http://","").gsub("/posts","").gsub("/","")
						new_pr_other = new_pr_other.to_s
					else
						new_pr_other = ""
					end			
				else
						new_pr_other = ""
				end				
				@user.update_attribute(:pr_other, new_pr_other)
				@user.update_attribute(:updated_at, Time.now)
				sign_in @user	
			elsif new_pr_other_length == 0
				@user.update_attribute(:pr_other, new_pr_other)
				@user.update_attribute(:updated_at, Time.now)
				sign_in @user			
			end	
			

			flash[:success] = "your store settings have been saved. [X] close"
			redirect_to :back	

		end
		
	end
end


	  
 
 private
	def is_numeric?(s)
	  begin
		Float(s)
	  rescue
		false # not numeric
	  else
		true # numeric
	  end
	end

	def is_a_valid_email?(email)
	  # Check the number of '@' signs.
	  if email.count("@") != 1 then
		return false
	  # We can now check the email using a simple regex.
	  # You can replace the TLD's at the end with the TLD's you wish
	  # to accept.
	  elsif email =~ /^.*@.*(.com|.org|.net|.gov|.biz|.co|.info|.us|.name|.edu|.mobi)$/ then
		return true
	  else
		return false
	  end
	end

end
