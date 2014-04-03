class ItemsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy 
  before_filter :set_cache_buster


  def set_cache_buster
   response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
   response.headers["Pragma"] = "no-cache"
   response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
  
  require 'mail'

  
 # def index
#	@tags = Item.tag_counts_on(:tags)
 # end
  
#  def tag_cloud
 #   @tags = Item.tag_counts_on(:tags)
 # end   
 
   
		
		 
  
  def index
    @title = "all items"
    @items = Item.paginate(:page => params[:page], :per_page => 15)
       if signed_in?
		 @item = Item.new
	  end    
	  
		#@item = Item.find(:all, :select => "id,image,th_height,th_width")
		#@item = Item.find(:all, :select => "items.id, items.image, items.views_count, items.th_height, items.th_width, count(circlerelationships.circle_id) as circlecount", :joins => "LEFT JOIN `circlerelationships` ON items.id = circlerelationships.item_id", :conditions => "circlerelationships.circle_id > 0 OR circlerelationships.circle_id IS NULL", :limit =>"0,300", :group => "circlerelationships.item_id").paginate(:per_page => 100, :page => params[:page])
		#@item = Item.find(:all, :select => "items.id, items.image, items.views_count, items.th_height, items.th_width, count(likes.user_ID) as likes_count", :joins => "LEFT JOIN likes ON items.id = likes.item_id", :group => "items.id", :limit =>"20,300", :conditions => ["items.flagged = ? AND items.is_sold = ?", "N", "N"]).paginate(:per_page => 15, :page => params[:page]) 
		
		#begin good queries
		#mysql version
		#@item = Item.find(:all, :select => "items.id, items.image, items.views_count, items.th_height, items.th_width, count(DISTINCT likes.user_ID) as likes_count, Count(DISTINCT circlerelationships.circle_id) as circle_count, CONVERT(REPLACE(GROUP_CONCAT(DISTINCT CONCAT('#',tags.name)),',',' '),BINARY) as tags", :joins => "LEFT JOIN likes ON items.id = likes.item_id LEFT JOIN circlerelationships ON items.id = circlerelationships.item_id LEFT JOIN taggings ON items.id = taggings.taggable_id LEFT JOIN tags ON taggings.tag_id = tags.id", :group => "items.id", :limit =>"20,300", :conditions => ["items.flagged = ? AND items.is_sold = ?", "N", "N"]).paginate(:per_page => 15, :page => params[:page]) 		
		#postgres version
		#@item = Item.find(:all, :select => "items.id, items.image, items.views_count, items.th_height, items.th_width, count(DISTINCT likes.user_ID) as likes_count, Count(DISTINCT circlerelationships.circle_id) as circle_count, CAST(array_to_string(array_agg(DISTINCT CONCAT('#' || tags.name)))) as tags", :joins => "LEFT JOIN likes ON items.id = likes.item_id LEFT JOIN circlerelationships ON items.id = circlerelationships.item_id LEFT JOIN taggings ON items.id = taggings.taggable_id LEFT JOIN tags ON taggings.tag_id = tags.id", :group => "items.id", :limit =>"20", :offset => "300", :conditions => ["items.flagged = ? AND items.is_sold = ?", "N", "N"]).paginate(:per_page => 15, :page => params[:page]) 		
		#@item = Item.find(:all, :select => "items.id, items.image, items.views_count, items.th_height, items.th_width, count(DISTINCT likes.user_ID) as likes_count, Count(DISTINCT circlerelationships.circle_id) as circle_count, CAST('BINARY' AS GROUP_CONCAT('#' || tags.name)) as tags", :joins => "LEFT JOIN likes ON items.id = likes.item_id LEFT JOIN circlerelationships ON items.id = circlerelationships.item_id LEFT JOIN taggings ON items.id = taggings.taggable_id LEFT JOIN tags ON taggings.tag_id = tags.id", :group => "items.id", :limit =>"20", :offset => "300", :conditions => ["items.flagged = ? AND items.is_sold = ?", "N", "N"]).paginate(:per_page => 15, :page => params[:page]) 		
		
		#line below was last good sql before find_by_sql
		#@item = Item.find(:all, :select => "items.id, items.image, items.views_count, items.th_height, items.th_width, count(DISTINCT likes.user_ID) as likes_count, Count(DISTINCT circlerelationships.circle_id) as circle_count, string_agg(tags.name,'#') as tags", :joins => "LEFT JOIN likes ON items.id = likes.item_id LEFT JOIN circlerelationships ON items.id = circlerelationships.item_id LEFT JOIN taggings ON items.id = taggings.taggable_id LEFT JOIN tags ON taggings.tag_id = tags.id", :group => "items.id", :limit =>"300", :offset => "20", :conditions => ["items.flagged = ? AND items.is_sold = ?", 'N', 'N']).paginate(:per_page => 15, :page => params[:page]) 		
		#@item = Item.find(:all, :select => "items.id, items.image, items.views_count, items.th_height, items.th_width, count(DISTINCT likes.user_ID) as likes_count, Count(DISTINCT circlerelationships.circle_id) as circle_count", :joins => "LEFT JOIN likes ON items.id = likes.item_id LEFT JOIN circlerelationships ON items.id = circlerelationships.item_id LEFT JOIN taggings ON items.id = taggings.taggable_id LEFT JOIN tags ON taggings.tag_id = tags.id", :group => "items.id", :limit =>"300", :offset => "20", :conditions => ["items.flagged = ? AND items.is_sold = ?", "N", "N"]).paginate(:per_page => 15, :page => params[:page]) 		
		
		
		@item = Item.find_by_sql(["SELECT ALL items.id, items.title, items.tinyurl, items.price, items.image, items.views_count, items.is_sold, items.created_at, items.th_height, items.th_width, count(DISTINCT likes.user_ID) as likes_count, " +
		"COUNT(DISTINCT circlerelationships.circle_id) as circle_count, " +
		"string_agg(DISTINCT tags.name,',') as tags " +
		"FROM items " +
		"LEFT JOIN likes ON items.id = likes.item_id  " +
		"LEFT JOIN circlerelationships ON items.id = circlerelationships.item_id  " +
		"LEFT JOIN taggings ON items.id = taggings.taggable_id  " +
		"LEFT JOIN tags ON taggings.tag_id = tags.id " +
		"WHERE items.flagged = 'N'AND items.is_sold = 'N' " +
		"GROUP BY items.id " +
		"LIMIT 500 OFFSET 20"]).paginate(:per_page => 15, :page => params[:page]) 		
		
		
		
		#@item2 = Item.find(:all, :select => "items.id, count(likes.user_ID) as likecount", :joins => "LEFT JOIN likes ON items.id = likes.item_id", :conditions => ["items.flagged = ? AND items.is_sold = ?", "N", "N"], :group => "likes.item_id", :limit =>"0,300").paginate(:per_page => 20, :page => params[:page])
		
		#@item2 = 
		#@item = @item + @item2
		#'"categories".id, "categories".name, count("articles".id) as counter'
		respond_to do |format|
          format.js { render_json @item.to_json }
        end

  end
  

  def api
		@item = Item.find(:all, :conditions => ["user_id != ? AND items.flagged = ? AND items.is_sold = ?", current_user.id, "N", "N"], :select => "items.id, items.image, items.price, items.views_count, items.th_height, items.th_width, count(likes.user_ID) as likes_count", :joins => "LEFT JOIN likes ON items.id = likes.item_id", :group => "items.id", :limit =>"20,300").paginate(:per_page => 15, :page => params[:page]) 
		respond_to do |format|
          format.js { render_json @item.to_json }
        end
  end  
 
 
 
  def show
  
	#@lookuptiny = 'mdb0a6'
	#params[:tinyurl]
	#unless Item.find_by_sql(["SELECT * FROM items WHERE items.tinyurl = ? LIMIT 1 ;", @lookuptiny ]).nil?
	
	if not params[:id].nil?
	
		#@itempre = Item.find_by_id(params[:id])
		@itemseotitle = Item.find_by_id(params[:id]).title.strip
		@itemtinyurl = Item.find_by_id(params[:id]).tinyurl.strip	
		if @itemseotitle.length > 4	
			redirect_to root_url+'p/'+@itemtinyurl+'/'+@itemseotitle+'/', :status => :moved_permanently
		else
			redirect_to root_url+'p/'+@itemtinyurl+'/', :status => :moved_permanently
		end
		
	else
	
			unless Item.find_by_tinyurl(params[:tinyurl]).nil?
				
			
			 
			  
				  @item = Item.find_by_tinyurl(params[:tinyurl])
				  
				  @deftitle = " for sale"
				  @tags = Item.find_by_tinyurl(params[:tinyurl]).tag_counts_on(:tags)    
				  @items = Item.find_by_tinyurl(params[:tinyurl])
				  @itemzooms = Item.find_by_tinyurl(params[:tinyurl]) 
				  @itemuserid = @items.user_id
				  @useragent = request.env["HTTP_USER_AGENT"]
				  @itemseotitle = Item.find_by_tinyurl(params[:tinyurl]).title.strip
				  @itemtinyurl = Item.find_by_tinyurl(params[:tinyurl]).tinyurl.strip
				  
				  #check to see if user is deleted  
				  @usercheck = User.find_by_id(@itemuserid)
				  @deletecheck = @usercheck.deleted		  
				  
				  #canonical urls for items
				  @itemshow = @item.id 
				  #canonical_url(item_url(@itemshow))
				  if @itemseotitle.nil?
					canonical_url(root_url+'p/'+params[:tinyurl]+'/')
				  else
					canonical_url(root_url+'p/'+params[:tinyurl]+'/'+@itemseotitle+'/') 
				  end
				  
				  
				 # @itemwidth = @item.image.width.to_s
				   

				  #try delayed job for creating tiny url code
				  if @items.tinyurl.empty?
					  #def createtinyurl
					  
							def random_string(length)  
								rand(36**length).to_s(36)  
							end  
							
							@shortcode = random_string 7   
							
							@codecheck = Item.find(:first, :conditions => ["tinyurl = ?", @shortcode])    
							if @codecheck.nil?
							   @item.tinyurl = @shortcode
							   @item.save
							end  
					  
					  #end
					  #handle_asynchronously :createtinyurl, :run_at => Proc.new { 2.minutes.from_now }  
				  end


					  @items = Item.find_by_tinyurl(params[:tinyurl])
					
					  #begin ping functions
					  #check for public pings, and userID is not current user ID
					  @pingcheckpublic = Ping.find(:all, :conditions => ["item_id = ? AND public = ?", @item.id, "Y"])
					  #check for private pings
					  @pingcheckprivate = Ping.find(:all, :conditions => ["item_id = ? AND public = ?", @item.id, "N"])	
						
					  #public pings count
					  if not @pingcheckpublic.nil?
						 @publicpingcount = @pingcheckpublic.count
					  else
						 @publicpingcount = 0
					  end            
					  
					  #private pings count
					  if not @pingcheckprivate.nil?
						 @privatepingcount = @pingcheckprivate.count 
					  else
						 @privatepingcount = 0
					  end          	
					

				  if signed_in?
				  
					  @item_id = @item.id.to_s	
					  
					  #check to see if item is in any circles by current user
					  @circlescheck = Circle.find(:all, :limit =>1,
					  :select => "DISTINCT circles.id, circles.public, circles.name, circles.created_at", :joins => "LEFT JOIN circlerelationships ON circles.id = circlerelationships.circle_id" ,
					  :conditions => ['user_id = ? AND circlerelationships.item_id = ?', current_user.id, @item_id])
					  
					  if @circlescheck.empty?
						 #this query is slightly moded to account for if the user has never addded this item to a circle
						 @circles = Circle.find(:all, :limit => 10, 
						 :select => "DISTINCT circles.id, circles.public, circles.name, circles.created_at", :joins => "LEFT JOIN circlerelationships ON circles.id = circlerelationships.circle_id" ,
						 :conditions => ['user_id = ? AND (circlerelationships.circle_ID <> (SELECT circles.id FROM circles INNER JOIN circlerelationships ON circles.id = circlerelationships.circle_id WHERE user_id = ? AND circlerelationships.item_id = ? ) OR circlerelationships.item_id IS ? OR circlerelationships.item_id <> ?)', current_user.id, current_user.id, @item_id, nil, @item_id])
					  else
						 #this query is more closed because item has already been added to a circle
						 @circles = Circle.find(:all, :limit => 10, 
						:select => "DISTINCT circles.id, circles.public, circles.name, circles.created_at", :joins => "LEFT JOIN circlerelationships ON circles.id = circlerelationships.circle_id" ,
						:conditions => ['user_id = ? AND (circlerelationships.circle_ID NOT IN (SELECT circles.id FROM circles INNER JOIN circlerelationships ON circles.id = circlerelationships.circle_id WHERE user_id = ? AND circlerelationships.item_id = ? ) OR circlerelationships.item_id IS ?)', current_user.id, current_user.id, @item_id, nil])
					  end
			 
						
					  @circlerelationships = Circlerelationship.find(:all)
					  @testtag =  @circles.count 
					  @likecheck = Like.find(:first, :conditions => ["item_id = ? AND user_id = ? AND deleted = ?", @item.id, current_user.id, "N"])

					  #check for pings from current user on this item
					  @pingcheck = Ping.find(:first, :select => "*", :conditions => ["item_id = ? AND user_id = ?", @item.id, current_user.id], :limit => "1")

					  
					  if @pingcheck.nil?
						 @pingswitch = "on"
					  else
						  @pingcontent = @pingcheck.content.to_s
						  @pingcreated = @pingcheck.created_at.to_s
						  @pingstatus = @pingcheck.public.to_s
					  end
					  
					  
				  end     
				  
				  #get actual count of item likes
				  @likes = Like.find(:all, :conditions => ["item_id = ? AND deleted = ?", @item.id, "N"])
				  @likescountreal = @likes.count
				  #check to see if item is already liked by user
				  
				  
				  if @likecheck.nil?
						@likemessage = "notliked"
				  else
						@likemessage = "isliked"
						@liketimedate = @likecheck.created_at
				  end 
				  
				  
				  #update views count
				  if @useragent.downcase.include?("google") || @useragent.downcase.include?("yahoo") || @useragent.downcase.include?("msn") || @useragent.downcase.include?("robot") || @useragent.downcase.include?("bot") || @useragent.downcase.include?("spider") || @useragent.downcase.include?("crawl")
				  else
					@viewscount = @item.views_count + 1
					@itemupdate = Item.find_by_sql(["UPDATE items SET views_count = ? WHERE id = ?", @viewscount, params[:id]])
				  end
				  
				  #update user likes
				  if signed_in?
					  if params[:p].nil?
						  @likescount = @likescountreal
					  else
						  if params[:p].to_s == "like"
							#need to check if current user has already liked item, if not like item            
							if @likecheck.nil?
							
									@user_id = current_user.id
									@like = Like.new(:user_id => current_user.id, :item_id => @item_id, :deleted => "N")  
									@like.save
									@likemessage = "isliked"
									@likecheck = Like.find(:first, :conditions => ["item_id = ? and user_id = ?", @item.id, current_user.id])
									@liketimedate = @likecheck.created_at
									#@likes = Like.find(:all, :conditions => ["item_id = ?", @item.id])
									@likes = Like.find(:all, :conditions => ["item_id = ? AND deleted = ?", @item.id, "N"])
									@likescountreal = @likes.count				
								end       
							  
								@likescount = @likescountreal
								flash[:success] = "cool! you've liked this photo. [x] close."	
								redirect_to :back			
								#redirect_to item_path
								#	  if @itemseotitle.nil?
								#		redirect_to root_url+'p/'+params[:tinyurl]+'/'
								#	  else
								#		redirect_to root_url+'p/'+params[:tinyurl]+'/'+@itemseotitle+'/'
								#	  end
							
						  elsif params[:p].to_s == "unlike"
						  
									@user_id = current_user.id
									#@like = Like.new(:user_id => current_user.id, :item_id => @item_id)  
									#@like.save
									@like = Like.find_by_sql(["DELETE FROM likes WHERE likes.user_id = ? AND likes.item_id = ?", @user_id, @item_id])
									#this blew up from rails like/unlike duplicate function
									#@likedelete = Like.find_by_sql(["UPDATE likes SET (deleted, deleted_at) = (?,?) WHERE likes.user_id = ? AND likes.item_id = ?", 'Y', @currentts, @user_id, @item_id])

									#@likes = Like.find(:all, :conditions => ["item_id = ?", @item.id])
									@likes = Like.find(:all, :conditions => ["item_id = ? AND deleted = ?", @item.id, "N"])
									@likescountreal = @likes.count				
						  
								@likescount = @likescountreal
								flash[:notice] = "you've unliked this photo. [x] close."	
								redirect_to :back			
								#redirect_to item_path	
								#	  if @itemseotitle.nil?
								#		redirect_to root_url+'p/'+params[:tinyurl]+'/'
								#	  else
								#		redirect_to root_url+'p/'+params[:tinyurl]+'/'+@itemseotitle+'/'
								#	  end  
						  
						  end
					  end 
					end
					  
					@circlespartof = Circlerelationship.find(:all, :conditions => ["item_id = ?", @item.id])
					if @circlespartof.nil?
						@circlespartofcount = 0
					else
						@circlespartofcount = @circlespartof.count
					end      

				  if @tags.empty? 
						   @tagsforitem = " "
				  else
					   @tags.each do |tag| 
							@tagsforitem = @tagsforitem.to_s+" #"+tag.name.to_s
						  end
				  end
				  

				  
				  #to get fields from zipcode table
				  #@bees = Item.includes(:zipcode).all
				 
				  if not @items.zipcode.blank?  
					  @long = @items.zipcode.longitude
					  @lat = @items.zipcode.latitude
					  @zip = @items.zipcode_id
					  @city = @items.zipcode.citymixedcase
					  @state = @items.zipcode.state
					  @itemusername = @items.user.name
				  else
					  @itemusername = @items.user.name
				  end
				  
				  @title = @tagsforitem.gsub("#", "").strip! + " for sale"
				  @meta_description = @tagsforitem.gsub(" #", " ").titlecase.strip! + " for sale"
				  if not @city.nil?
					@meta_description = @meta_description + " near " + @city.to_s + ", " + @state.to_s
				  end		  
				  @meta_keywords = @tagsforitem.gsub(" #", " ").strip!
				  if @meta_keywords.nil?
					   @meta_keywords = ""
				  else   
					   @meta_keywords = @meta_keywords.gsub(/,*\s+/,',')
				  end		  
				  
				  #old way to get from items table
				 # @long = @items.location_longitude
				 #  @lat = @items.location_latitude	
				  
				  #get tiny url
				  if @items.tinyurl != ""
						@tinyurl = "fsp.lc/" + @items.tinyurl.to_s
				  end
				  #get embed code
				  if @items.image != ""
						@image_urlembed = @items.image.to_s
						if @itemseotitle.length > 5
							@ahrefitem = root_url+'p/'+params[:tinyurl]+'/'+@itemseotitle+'/'
						else
							@ahrefitem = root_url+'p/'+params[:tinyurl]+'/'
						end
						#.gsub("https://s3.amazonaws.com/images.forsalephoto.com", "http://images.forsalephoto.com").gsub("https://images.forsalephoto.com.s3.amazonaws.com", "http://images.forsalephoto.com")
						@image_urlembed_final = @image_urlembed.gsub("https://s3.amazonaws.com/images.forsalephoto.com", "http://images.forsalephoto.com").gsub("https://s3.amazonaws.com/images.forsalephoto.com", "http://images.forsalephoto.com").gsub("https://images.forsalephoto.com.s3.amazonaws.com", "http://images.forsalephoto.com").gsub("https://img-cache-01.forsalephoto.com.s3.amazonaws.com/item/","http://img-cache-01.forsalephoto.com/item/")
						@embedcode01 = "<div style='padding-bottom: 2px; line-height: 0px'><a href='http://" + @tinyurl.to_s + "' target='_blank'><img style='width: 70%' src='" + @image_urlembed_final.to_s + "' border='0' title='" + @tagsforitem.gsub("#", "").strip.to_s + "' alt='" + @tagsforitem.gsub("#", "").strip.to_s + "' /></a></div>"
						@embedcode02 = "<div style='float: center; padding-top: 0px; padding-bottom: 0px;'><p style='font-size: 11px; color: #333;'>posted by: <a style='text-decoration: underline; font-size: 11px; color: #333;' href='http://forsalephoto.com/" + @itemusername.to_s + "/' target='_blank'>" + @itemusername.to_s + "</a> on <a style='text-decoration: underline; color: #76838b;' href='http://forsalephoto.com' target='_blank'>forsalephoto</a></p></div>"
				  end
						
				 # this is close for view saves
				 # @items.views += 1
				 # @items.save
				 
				  if signed_in?
					 @item = Item.new
				  end
				  
				  #for tweeting item
					@tags.each do |tag| 
						if is_numeric?(tag.name.to_s)
						else
							@hashtagsstr = @hashtagsstr.to_s + tag.name.to_s + ","
						end
					end
			
			else
				redirect_to root_path
			end

		end

  end
 
  
  def new
  end 

  def create
    @item  = current_user.items.build(params[:item])
    @user = current_user
    @image = current_user.items.build(params[:image])
    
    emailadd = current_user.email
    username = current_user.name
   

    #@tinyurl = current_user.items.Base32::Crockford.encode(11005, :length=>6)
    #@image_th = current_user.items.build(params[:th])
    #@location_latitude = location_latitude
    #@location_longitude = location_longitude

    if @item.save
    
        imageid = @item.id.to_s
        time = Time.new
        rooturl  = "#{request.protocol}#{request.host_with_port}"
        
        @itemactive = Item.find_by_sql(["UPDATE items SET deleted = ? WHERE id = ?", "N", imageid])
        #@items = Item.find_by_id(imageid.to_i)
        
        #@item.each do |item|
		#	@image_width = item.lg_width.to_s.strip
		#	@image_height = item.lg_height.to_s.strip      
       # end
        
        #update some fields
        @client_ip = remote_ip()
        #@image_width = @items.lg_width.to_s.strip
	    #@image_height = @items.lg_height.to_s.strip
        @item.update_attribute(:client_ip, @client_ip)
        #@item.update_attribute(:width, @image_width)
        #@item.update_attribute(:height, @image_height)
        
		  #try delayed job for creating tiny url code
		  if @item.tinyurl.empty?
			  #def createtinyurl
			  
					def random_string(length)  
						rand(36**length).to_s(36)  
					end  
					@shortcode = random_string 7   
					
					@codecheck = Item.find(:first, :conditions => ["tinyurl = ?", @shortcode])    
					if @codecheck.nil?
					   #@item.tinyurl = @shortcode
					   #@item.save
					   @item.update_attribute(:tinyurl, @shortcode)
					else
						#try again if already used
						@shortcode2 = random_string 7 
						@codecheck2 = Item.find(:first, :conditions => ["tinyurl = ?", @shortcode2]) 
						if @codecheck2.nil?
							@item.update_attribute(:tinyurl, @shortcode2)
						end					 
					end  
			  
			  #end
			  #handle_asynchronously :createtinyurl, :run_at => Proc.new { 2.minutes.from_now }  
		  end        
        
        
        #send email notifying that new item posted
    
		smtp = { :address => 'mail.forsalephoto.com', :port => 26, :domain => 'forsalephoto.com', :user_name => 'notification@forsalephoto.com', :password => '!7guRjMx34', :enable_starttls_auto => true, :openssl_verify_mode => 'none' }
        Mail.defaults { delivery_method :smtp, smtp }    
		mail = Mail.new do
		from    'forsalephoto <notification@forsalephoto.com>'
		to      emailadd
		subject 'congratulations - your photo has been uploaded'
		
		 html_part do
			content_type 'text/html; charset=UTF-8'
			
			#orig html code for email
			#body 'Hey '+username+',<br/><br/>Your new for sale photo has been successfully uploaded!<br/><br/>If you have not already done so, you can <font color=#000099>increase your exposure</font> by<br/>adding <font color=#000099>relative tags</font> to your photo, as well as the <font color=#000099>price of the item</font> for sale.<br/><br/>Its easy, you can <b>edit the tags</b> and <b>price of your item</b> by by visiting this link: <a href=http://localhost:3000/items/'+imageid+'/edit>http://localhost:3000/items/'+imageid+'/edit</a><br/><br/>Thank you for using our service!<br/><br/><br/><b><font size=3>forsalephoto</font></b><br/><i>your place to post and share photos of items for sale</i><br/><a href=http://forsalephoto.com/>forsalephoto.com</a><br/><br/>'
		  
		 
		 	body '<table cellspacing="0" cellpadding="0" border="0" width="100%">
											<tr>
												<td bgcolor=#cccccc height="90" valign="middle" align="center">
														
														<a href="http://forsalephoto.com"><img src=http://asset-cache-01.forsalephoto.com/logo-center-99.png  align="center" border="0" style="margin-top:7px;margin-right:10px;"></a>
					
												</td>
											</tr>
											<tr>
												<td bgcolor="#f4f4f4" height="120">
												
													<table border="0" align="center" cellpadding="0" cellspacing="0" width="50%">
														<tbody>
															<tr>
																<td align="center" valign="top" style="color:#808080;font-family:Trebuchet MS;font-size:20px;line-height:100%;letter-spacing:-1px;text-align:center">																
																	<h1 style="display:block;font-family:Trebuchet MS;font-style:normal;line-height:115%;margin-top:10px;margin-right:0;margin-bottom:0;margin-left:0;font-size:24px;letter-spacing:-1px;text-align:center;font-weight:500;color:#202020;text-decoration:none">hey '+username+', your photo has been successfully uploaded!</h1>
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
																	<a href="'+rooturl+'/items/'+imageid+'" style="text-decoration: none;" title="view posted ad"><h2 style="display:block;font-family:Helvetica;font-style:normal;line-height:115%;margin-top:0;margin-right:0;margin-bottom:0;margin-left:0;font-size:24px;letter-spacing:-1px;text-align:center;font-weight:bold;color:#F15A29;text-decoration:none">show photo</h2></a>
																	<p style="color:#666;margin-top:15px;font-weight:500;font-family:Trebuchet MS;">#tags #tags #tags #tags</p>
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
																		<a href="'+rooturl+'/items/'+imageid+'" title="view posted ad" style="font-family:Trebuchet MS;font-size:20px;font-weight:500;line-height:100%;letter-spacing:-.5px;text-align:center;text-decoration:none;color:#ffffff" target="_blank"><span style="font-family:Trebuchet MS;font-size:20px;font-weight:500;line-height:100%;letter-spacing:-.5px;text-align:center;text-decoration:none;color:#ffffff">view posted ad</span></a>
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
																	<p style="color:#666;margin-top:-12px;font-weight:500;font-family:Trebuchet MS;font-size:0.7em;">
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
		
		## !!!!!!  ------ COMMENTED OUT BELOW TO STOP EMAILS FOR NOW
		# mail.deliver!
    
    
	   flash[:success] = "success, your photo was uploaded. [x] close"  
       redirect_to action: "edit", id: imageid
       #redirect_to current_user
	   #redirect_to root_path
	   #redirect_to @item
       #render 'pages/about'
    else
      @feed_items_photos = []
      flash[:error] = "oops, perhaps an image file was not selected? [x] close"  
      #@render 'pages/home'
      redirect_to user_path(current_user)
    end
  
   
  end
  
  

  def edit

	
	 #Item.find_by_tinyurl(params[:tinyurl]).nil?
	  
     @title = "edit item for sale"
     @items = Item.find(params[:id])
     @item = Item.find(params[:id])
     @user = current_user
     @tempprice = Item.find(params[:id]).price
     @tempuserid = Item.find(params[:id]).user_id
     @tempitemstatus = Item.find(params[:id]).is_sold.strip
     @itemseotitle = Item.find(params[:id]).title.strip
     
     
     		#try delayed job for creating tiny url code
		  if @item.tinyurl.empty?
			  #def createtinyurl
			  
					def random_string(length)  
						rand(36**length).to_s(36)  
					end  
					@shortcode = random_string 7   
					
					@codecheck = Item.find(:first, :conditions => ["tinyurl = ?", @shortcode])    
					if @codecheck.nil?
					   #@item.tinyurl = @shortcode
					   #@item.save
					   @item.update_attribute(:tinyurl, @shortcode)
					else
						#try again if already used
						@shortcode2 = random_string 7 
						@codecheck2 = Item.find(:first, :conditions => ["tinyurl = ?", @shortcode2]) 
						if @codecheck2.nil?
							@item.update_attribute(:tinyurl, @shortcode2)
						end					 
					end  
			  
			  #end
			  #handle_asynchronously :createtinyurl, :run_at => Proc.new { 2.minutes.from_now }  
		  end     
     
     
     @itemtinyurl = Item.find(params[:id]).tinyurl.strip
    #@temp_width = Item.find(params[:id]).lg_width.to_s
   # @temp_width =  item.lg_height.to_s.strip
   # @temp_height = Item.find(params[:id]).lg_height.to_s

     
   #  @items.each do |item|
	#		@temp_width = item.lg_width.to_s.strip
	#		@temp_height = item.lg_height.to_s.strip      
   #   end
     
    # fresh_when(@item)
     
     #get views count
     @viewscount = @item.views_count
     
     #redirect if user enters edit directly in url
     if current_user.nil?
		redirect_to @item 
     else
		 if current_user.id == @tempuserid
		 else
			redirect_to @item 
		 end
	 end
     #@tags = Item.tag_counts_on(:tags)
     @tags = Item.find(params[:id]).tag_counts_on(:tags)
     
     @message = @tags.each do |tag| tag.name
     end
     
     #  def tag_cloud
     #    @tags = Item.tag_counts_on(:tags)
     #  end 
       
		  #begin ping functions
          #check for public pings, and userID is not current user ID
          @pingcheckall = Ping.find(:all, :conditions => ["item_id = ?", @items.id])
          #check for private pings
          #@pingcheckprivate = Ping.find(:all, :conditions => ["item_id = ?", @item.id, "N"])
          
          if @pingcheckall.nil?
              @pingstatus = "no pings for this item."
          end	       
       
       
      if @tags.empty? 
               @tagsforitem = ""
      else
           @tags.each do |tag| 
					 if @tagsforitem.nil?
						@tagsforitem = "#"+tag.name.to_s
					 else
						@tagsforitem = @tagsforitem.to_s+" #"+tag.name.to_s
					 end
	          end
	  end 
	  
	  if not @items.zipcode.blank?
		  
		  @bees = Item.includes(:zipcode).all
		  @long = @items.zipcode.longitude
		  @lat = @items.zipcode.latitude
		  @zip = @items.zipcode_id
		  @city = @items.zipcode.citymixedcase
		  @state = @items.zipcode.state     
		  @itemusername = @items.user.name
	  else
		  @itemusername = @items.user.name
	  end
	  

	  
	  #circles count
		@circlespartof = Circlerelationship.find(:all, :conditions => ["item_id = ?", @item.id])
		if @circlespartof.nil?
			@circlespartofcount = 0
		else
			@circlespartofcount = @circlespartof.count
		end  
		
	  #ping counts
	  	  #begin ping functions
          #check for public pings, and userID is not current user ID
          @pingcheckpublic = Ping.find(:all, :conditions => ["item_id = ? AND public = ?", @item.id, "Y"])
          #check for private pings
          @pingcheckprivate = Ping.find(:all, :conditions => ["item_id = ? AND public = ?", @item.id, "N"])	
          	
          #public pings count
          if not @pingcheckpublic.nil?
             @publicpingcount = @pingcheckpublic.count
          else
             @publicpingcount = 0
          end            
          
          #private pings count
          if not @pingcheckprivate.nil?
             @privatepingcount = @pingcheckprivate.count 
          else
             @privatepingcount = 0
          end 
          
      #get item likes
		@likes = Like.find(:all, :conditions => ["item_id = ?", @item.id])
		@likescountreal = @likes.count
	  
	  #get tiny url
	  if @items.tinyurl != ""
			@tinyurl = "fsp.lc/" + @items.tinyurl.to_s
	  end
	  #get embed code
	  if @items.image != ""
				@image_urlembed = @items.image.to_s
				if @itemseotitle.length > 5
					@ahrefitem = root_url+'p/'+@itemtinyurl.to_s+'/'+@itemseotitle.to_s+'/'
				else
					@ahrefitem = root_url+'p/'+@itemtinyurl.to_s+'/'	
				end				
				#.gsub("https://s3.amazonaws.com/images.forsalephoto.com", "http://images.forsalephoto.com").gsub("https://images.forsalephoto.com.s3.amazonaws.com", "http://images.forsalephoto.com")
				@image_urlembed_final = @image_urlembed.gsub("https://s3.amazonaws.com/images.forsalephoto.com", "http://images.forsalephoto.com").gsub("https://s3.amazonaws.com/images.forsalephoto.com", "http://images.forsalephoto.com").gsub("https://images.forsalephoto.com.s3.amazonaws.com", "http://images.forsalephoto.com").gsub("https://img-cache-01.forsalephoto.com.s3.amazonaws.com/item/","http://img-cache-01.forsalephoto.com/item/")
				@embedcode01 = "<div style='padding-bottom: 2px; line-height: 0px'><a href='" + @ahrefitem.to_s + "' target='_blank'><img style='width: 70%' src='" + @image_urlembed_final.to_s + "' border='0' title='" + @tagsforitem.gsub("#", "").strip.to_s + "' alt='" + @tagsforitem.gsub("#", "").strip.to_s + "' /></a></div>"
				@embedcode02 = "<div style='float: center; padding-top: 0px; padding-bottom: 0px;'><p style='font-size: 11px; color: #333;'>posted by: <a style='text-decoration: underline; font-size: 11px; color: #333;' href='http://forsalephoto.com/" + @itemusername.to_s + "/' target='_blank'>" + @itemusername.to_s + "</a> on <a style='text-decoration: underline; color: #76838b;' href='" + @ahrefitem.to_s + "' target='_blank'>forsalephoto</a></p></div>"
	  end	  

	  


  end
  
  def update
     @title = "edit item for sale"
     @items = Item.find(params[:id])
     @user = current_user
     @current_user_id_for_check = current_user.id  
     @item = Item.find(params[:id])
     #@user = @item.user
     #@item.tag_list = params[:newtags] || ''
     @user.owned_taggings
     @user.owned_tags
     @item_id = @item.id.to_s

     
#     if params[:newprice].nil?
 #       @newprice = ""
#     else
#		@newprice = params[:newprice].gsub(/[^\d\.]/, '').gsub("$","").to_i || ''
 #    end
 
     
     if not params[:newtags].nil?
     
        
        #old tagging way start
        #lines = params[:newtags].to_s.gsub(","," ").gsub("  "," ").gsub("#","")
		#stop_words = %w{show edit create update destroy a by on for of are the with but me etc is and to my I has some in if am now he she it able about above abroad according accordingly across actually adj after afterwards again against ago ahead ain't aint all allow allows almost alone along alongside already also although always am amid amidst among amongst an and another any anybody anyhow anyone anything anyway anyways anywhere apart appear appreciate appropriate are aren't around as a's aside ask asking associated at available away awfully back backward backwards be became because become becomes becoming been before beforehand begin behind being believe below beside besides best better between beyond both brief but by came can cannot cant can't caption cause causes certain certainly changes clearly c'mon cmon co co. com come comes concerning consequently consider considering contain containing contains corresponding could couldn't couldnt course c's currently dare daren't darent definitely described despite did didn't didnt different directly do does doesn't doesnt doing done don't dont down downwards during each edu eg eight eighty either else elsewhere end ending enough entirely especially et etc even ever evermore every everybody everyone everything everywhere ex exactly example except fairly far farther few fewer fifth first five followed following follows for forever former formerly forth forward found four from further furthermore get gets getting given gives go goes going gone got gotten greetings had hadn't hadnt half happens hardly has hasn't hasnt have haven't havent having he he'd hed he'll hello help hence her here hereafter hereby herein here's hereupon hers herself he's heres hes hi him himself his hither hopefully how howbeit however hundred i'd id ie if ignored i'll ill im i'm immediate in inasmuch inc inc. indeed indicate indicated indicates inner inside insofar instead into inward is isn't isnt it it'd itd it'll itll its it's itself i've ive just k keep keeps kept know known knows last lately later latter latterly least less lest let let's lets like liked likely likewise little look looking looks low lower ltd made mainly make makes many may maybe mayn't maynt me mean meantime meanwhile merely might mightn't mine minus miss more moreover most mostly mr mrs much must mustn't musnt my myself name namely nd near nearly necessary need needn't neednt needs neither never neverf neverless nevertheless new next nine ninety no nobody non none nonetheless noone no-one nor normally not nothing notwithstanding novel now nowhere obviously of off often oh ok okay old on once one ones one's only onto opposite or other others otherwise ought oughtnt oughtn't our ours ourselves out outside over overall own particular particularly past per perhaps placed please plus possible presumably probably provided provides que quite qv rather rd re really reasonably recent recently regarding regardless regards relatively respectively right round said same saw say saying says second secondly see seeing seem seemed seeming seems seen self selves sensible sent serious seriously seven several shall shan't shant shart she she'd shed she'll she's shes should shouldn't shouldnt since six so some somebody someday somehow someone something sometime sometimes somewhat somewhere soon sorry specified specify specifying still sub such sup sure take taken taking tell tends th than thank thanks thanx that that'll thatll thats that's thats that've thatve the their theirs them themselves then thence there thereafter thereby there'd thered therefore therein there'll therell there're therere theres there's thereupon there've thereve these they they'd theyd they'll theyll they're theyre they've theyve thing things think third thirty this thorough thoroughly those though three through throughout thru thus till to together too took toward towards tried tries truly try trying t's ts twice two un under underneath undoing unfortunately unless unlike unlikely until unto up upon upwards us use used useful uses using usually v value various versus very via viz vs want wants was wasn't wasnt way we we'd wed welcome well we'll went were we're weren't werent we've weve what whatever what'll whatll what's whats what've whatve when whence whenever where whereafter whereas whereby wherein where's wheres whereupon wherever whether which whichever while whilst whither who who'd whod whoever whole who'll wholl whom whomever who's whos whose why will willing wish with within without wonder won't wont would wouldn't wouldnt yes yet you you'd youd you'll youll your youre you're yours yourself yourselves you've youve anus arse arsehole ass ass-hat ass-jabber ass-pirate assbag assbandit assbanger assbite assclown asscock asscracker asses assface assfuck assfucker assgoblin asshat asshead asshole asshopper assjacker asslick asslicker assmonkey assmunch assmuncher assnigger asspirate assshit assshole asssucker asswad asswipe homosexual butt idiot jerk buttlicker bampot bastard beaner bitch bitchass bitches bitchtits bitchy blowjob blowjob bollocks bollox boner erection brotherfucker bullshit bumblefuck buttplug butt-pirate buttfucka buttfucker cameltoe carpetmuncher chinc chink choad chode clit clitface clitfuck clusterfuck cock cockass cockbite cockburger cockface cockfucker cockhead cockjockey cockknoker cockmaster cockmongler cockmongruel cockmonkey cockmuncher cocknose cocknugget cockshit cocksmith cocksmoker cocksniffer cocksucker cockwaffle coochie coochy coon cooter cracker cum cumbubble cumdumpster cumguzzler cumjockey cumslut cumtart cunnie cunnilingus cunt cuntass cuntface cunthole cuntlicker cuntrag cuntslut dago damn deggo dick dickbag dickbeaters dickface dickfuck dickfucker dickhead dickhole dickjuice dickmilk dickmonger dicks dickslap dicksucker dicksucking dickwad dickweasel dickweed dickwod dike dildo dipshit doochbag dookie douche douchebag douchewaffle dumass dumbasses dumbass dumbfuck dumbshit dumshit dyke fag fagbag fagfucker faggit faggots faggotcock fagtards fatass fellatio feltch flamers fuck fuckass fuckbag fuckboy fuckbrain fuckbutt fucked fucker fuckersucker fuckface fuckhead fuckhole fuckin fucking fucknut fucknutt fuckoff fucks fuckstick fucktard fucktart fuckup fuckwad fuckwit fuckwitt fudgepacker gay gayass gaybob gaydo gayfuck gayfuckist gaylord gaytard gaywad goddamn goddamnit gooch gook gringo guido handjob hardon heeb homo homodumbshit honkey humping jackass jap jerkoff jigaboo jizz junglebunny junglebunny kike kooch kootch kraut kunt kyke lameass lesbian lesbo lezzie mcfagget mick minge mothafucka mothafuckin motherfucker motherfucking muff muffdiver munging negro nigaboo nigga nigger niggerss nigletchild nutsack nutsack paki panooch pecker peckerhead penis penisfucker penispuffer piss pissed pissedoff pissflaps polesmoker pollock poon poonani poonany poontang porchmonkey porchmonkey prick punanny punta pussiess pussy pussylicking puto queef queer queerbait queerhole renob rimjob ruski retard sandnigger sandnigger schlong scrote shit shitass shitbag shitbagger shitbrains shitbreath shitcanned shitcunt shitdick shitface shitfaced shithead shithole shithouse shitspitter shitstain shitter shittiest shitting shitty shiz shiznit skank skeet skullfuck slut slutbag smeg snatch spic spick splooge spook suckass tard testicle thundercunt tit titfuck tits tittyfuck twat twatlips twatss twatwaffle unclefucker va-j-j vag vagina vjayjay wank wetback whore whorebag whoreface wop sex sexual sextoy genitals genitalia hussy ejaculate poop semen defecator jerk anus arsehole ass asshat assjabber ass-pirate assbag assbandit assbanger assbite assclown asscock asscracker asses assface assfuck assfucker assgoblin asshat asshead ass-hole asshopper assjacker asslick asslicker assmonkey assmunch assmuncher assnigger asspirate assshit asshole asssucker asswad asswipe homosexual butt idiot jerk buttlicker bampot bastard beaner bitch bitchass bitch-ass bitches bitchtits bitchy blowjob blow-job bollocks bollox boner erection brotherfucker bullshit bumblefuck buttplug butt-pirate buttfucka buttfucker cameltoe carpetmuncher chinc chink choad chode clit clitface clitfuck clusterfuck cock cockass cockbite cockburger cockface cockfucker cockhead cockjockey cockknoker cockmaster cockmongler cockmongruel cockmonkey cockmuncher cocknose cocknugget cockshit cocksmith cocksmoker cocksniffer cocksucker cockwaffle coochie coochy coon cooter cracker cum cumbubble cumdumpster cumguzzler cumjockey cumslut cumtart cunnie cunnilingus cunt cuntass cuntface cunthole cuntlicker cuntrag cuntslut dago damn deggo dick dickbag dickbeaters dickface dickfuck dickfucker dickhead dickhole dickjuice dickmilk dickmonger dicks dickslap dicksucker dicksucking dickwad dickweasel dickweed dickwod dike dildo dipshit doochbag dookie douche douche douchebag douchewaffle dumass dumbass dumb-ass dumbfuck dumbshit dumshit dyke fag fagbag fagfucker faggits faggot faggotcock fagtard fatass fellatio feltch flamer fucks fuckass fuckbag fuckboy fuckbrain fuckbutt fucked fucker fuckersucker fuckface fuckhead fuckhole fuckin fucking fucknut fucknutt fuckoff fucks fuckstick fucktard fucktart fuckup fuckwad fuckwit fuckwitt fudgepacker gays gayass gaybob gaydo gayfuck gayfuckist gaylord gaytard gaywad goddamn goddamnit gooch gook gringo guido handjob hardon heeb homo homodumbshit honkey humping jackass jap jerkoff jigaboo jizz junglebunny jungle-bunny kike kooch kootch kooter kraut kunt kyke lameass lesbian lesbo lezzie mcfagget mick minge muthafucka muthafuckin mutherfucker mutherfucking mothafucka mothafuckin motherfucker motherfucking muthafucka muthafuckin mutherfucker mutherfucking muff muffdiver munging negro nigaboo nigga niggas nigger niggers nigletchild nutsack nutsack paki panooch pecker peckerhead penis penisfucker penispuffer piss pissed pissedoff pissflaps polesmoker pollock poon poonani poonany poontang porchmonkey porch-monkey prick punanny punta pussie pussy pussylicking puto queef queer queerbait queerhole renob rimjob ruski retard sandnigger sand-nigger schlong scrote shit shitass shitbag shitbagger shitbrains shitbreath shitcanned shitcunt shitdick shitface shitfaced shithead shithole shithouse shitspitter shitstain shitter shittiest shitting shitty shiz shiznit skank skeet skullfuck slut slutbag smeg snatch spic spick splooge spook suckass tard testicle thundercunt tit titfuck tits tittyfuck twat twatlips twats twatwaffle unclefucker va-j-j vag vagina vjayjay wank wetback whore whorebag whoreface loser hoe hobag hobag hoebag hoebag cuntlicker cuntlicker ho-bag hoe-bag titty titties niger niggers niggas assholes nigggers asssholes assshole nigggas niggga nigggers pu$$y pusssy sandnigga sandnigga sand-nigga fart fagget piss pissy muthafucker muthafuck cumshot cumshot butthole junglebunnie cumlicker cumlicker cumface cuntwhore whorecunt fagot faget fagat fagget faggot faggat buttmunch}
		#@goodtags = lines.split.reject{|str|stop_words.include?(str)}
		#@tagscount = @goodtags.count
		#old tagging way end
		
		#clean tags
		lines = params[:newtags].to_s.gsub(","," ").gsub("  "," ").gsub("#","").downcase
		stop_words = %w{show edit create update destroy a by on for of are the with but me etc is and to my I has some in if am now he she it able about above abroad according accordingly across actually adj after afterwards again against ago ahead ain't aint all allow allows almost alone along alongside already also although always am amid amidst among amongst an and another any anybody anyhow anyone anything anyway anyways anywhere apart appear appreciate appropriate are aren't around as a's aside ask asking associated at available away awfully back backward backwards be became because become becomes becoming been before beforehand begin behind being believe below beside besides best better between beyond both brief but by came can cannot cant can't caption cause causes certain certainly changes clearly c'mon cmon co co. com come comes concerning consequently consider considering contain containing contains corresponding could couldn't couldnt course c's currently dare daren't darent definitely described despite did didn't didnt different directly do does doesn't doesnt doing done don't dont down downwards during each edu eg eight eighty either else elsewhere end ending enough entirely especially et etc even ever evermore every everybody everyone everything everywhere ex exactly example except fairly far farther few fewer fifth first five followed following follows for forever former formerly forth forward found four from further furthermore get gets getting given gives go goes going gone got gotten greetings had hadn't hadnt half happens hardly has hasn't hasnt have haven't havent having he he'd hed he'll hello help hence her here hereafter hereby herein here's hereupon hers herself he's heres hes hi him himself his hither hopefully how howbeit however hundred i'd id ie if ignored i'll ill im i'm immediate in inasmuch inc inc. indeed indicate indicated indicates inner inside insofar instead into inward is isn't isnt it it'd itd it'll itll its it's itself i've ive just k keep keeps kept know known knows last lately later latter latterly least less lest let let's lets like liked likely likewise little look looking looks low lower ltd made mainly make makes many may maybe mayn't maynt me mean meantime meanwhile merely might mightn't mine minus miss more moreover most mostly mr mrs much must mustn't musnt my myself name namely nd near nearly necessary need needn't neednt needs neither never neverf neverless nevertheless new next nine ninety no nobody non none nonetheless noone no-one nor normally not nothing notwithstanding novel now nowhere obviously of off often oh ok okay old on once one ones one's only onto opposite or other others otherwise ought oughtnt oughtn't our ours ourselves out outside over overall own particular particularly past per perhaps placed please plus possible presumably probably provided provides que quite qv rather rd re really reasonably recent recently regarding regardless regards relatively respectively right round said same saw say saying says second secondly see seeing seem seemed seeming seems seen self selves sensible sent serious seriously seven several shall shan't shant shart she she'd shed she'll she's shes should shouldn't shouldnt since six so some somebody someday somehow someone something sometime sometimes somewhat somewhere soon sorry specified specify specifying still sub such sup sure take taken taking tell tends th than thank thanks thanx that that'll thatll thats that's thats that've thatve the their theirs them themselves then thence there thereafter thereby there'd thered therefore therein there'll therell there're therere theres there's thereupon there've thereve these they they'd theyd they'll theyll they're theyre they've theyve thing things think third thirty this thorough thoroughly those though three through throughout thru thus till to together too took toward towards tried tries truly try trying t's ts twice two un under underneath undoing unfortunately unless unlike unlikely until unto up upon upwards us use used useful uses using usually v value various versus very via viz vs want wants was wasn't wasnt way we we'd wed welcome well we'll went were we're weren't werent we've weve what whatever what'll whatll what's whats what've whatve when whence whenever where whereafter whereas whereby wherein where's wheres whereupon wherever whether which whichever while whilst whither who who'd whod whoever whole who'll wholl whom whomever who's whos whose why will willing wish with within without wonder won't wont would wouldn't wouldnt yes yet you you'd youd you'll youll your youre you're yours yourself yourselves you've youve anus arse arsehole ass ass-hat ass-jabber ass-pirate assbag assbandit assbanger assbite assclown asscock asscracker asses assface assfuck assfucker assgoblin asshat asshead asshole asshopper assjacker asslick asslicker assmonkey assmunch assmuncher assnigger asspirate assshit assshole asssucker asswad asswipe homosexual butt idiot jerk buttlicker bampot bastard beaner bitch bitchass bitches bitchtits bitchy blowjob blowjob bollocks bollox boner erection brotherfucker bullshit bumblefuck buttplug butt-pirate buttfucka buttfucker cameltoe carpetmuncher chinc chink choad chode clit clitface clitfuck clusterfuck cock cockass cockbite cockburger cockface cockfucker cockhead cockjockey cockknoker cockmaster cockmongler cockmongruel cockmonkey cockmuncher cocknose cocknugget cockshit cocksmith cocksmoker cocksniffer cocksucker cockwaffle coochie coochy coon cooter cracker cum cumbubble cumdumpster cumguzzler cumjockey cumslut cumtart cunnie cunnilingus cunt cuntass cuntface cunthole cuntlicker cuntrag cuntslut dago damn deggo dick dickbag dickbeaters dickface dickfuck dickfucker dickhead dickhole dickjuice dickmilk dickmonger dicks dickslap dicksucker dicksucking dickwad dickweasel dickweed dickwod dike dildo dipshit doochbag dookie douche douchebag douchewaffle dumass dumbasses dumbass dumbfuck dumbshit dumshit dyke fag fagbag fagfucker faggit faggots faggotcock fagtards fatass fellatio feltch flamers fuck fuckass fuckbag fuckboy fuckbrain fuckbutt fucked fucker fuckersucker fuckface fuckhead fuckhole fuckin fucking fucknut fucknutt fuckoff fucks fuckstick fucktard fucktart fuckup fuckwad fuckwit fuckwitt fudgepacker gay gayass gaybob gaydo gayfuck gayfuckist gaylord gaytard gaywad goddamn goddamnit gooch gook gringo guido handjob hardon heeb homo homodumbshit honkey humping jackass jap jerkoff jigaboo jizz junglebunny junglebunny kike kooch kootch kraut kunt kyke lameass lesbian lesbo lezzie mcfagget mick minge mothafucka mothafuckin motherfucker motherfucking muff muffdiver munging negro nigaboo nigga nigger niggerss nigletchild nutsack nutsack paki panooch pecker peckerhead penis penisfucker penispuffer piss pissed pissedoff pissflaps polesmoker pollock poon poonani poonany poontang porchmonkey porchmonkey prick punanny punta pussiess pussy pussylicking puto queef queer queerbait queerhole renob rimjob ruski retard sandnigger sandnigger schlong scrote shit shitass shitbag shitbagger shitbrains shitbreath shitcanned shitcunt shitdick shitface shitfaced shithead shithole shithouse shitspitter shitstain shitter shittiest shitting shitty shiz shiznit skank skeet skullfuck slut slutbag smeg snatch spic spick splooge spook suckass tard testicle thundercunt tit titfuck tits tittyfuck twat twatlips twatss twatwaffle unclefucker va-j-j vag vagina vjayjay wank wetback whore whorebag whoreface wop sex sexual sextoy genitals genitalia hussy ejaculate poop semen defecator jerk anus arsehole ass asshat assjabber ass-pirate assbag assbandit assbanger assbite assclown asscock asscracker asses assface assfuck assfucker assgoblin asshat asshead ass-hole asshopper assjacker asslick asslicker assmonkey assmunch assmuncher assnigger asspirate assshit asshole asssucker asswad asswipe homosexual butt idiot jerk buttlicker bampot bastard beaner bitch bitchass bitch-ass bitches bitchtits bitchy blowjob blow-job bollocks bollox boner erection brotherfucker bullshit bumblefuck buttplug butt-pirate buttfucka buttfucker cameltoe carpetmuncher chinc chink choad chode clit clitface clitfuck clusterfuck cock cockass cockbite cockburger cockface cockfucker cockhead cockjockey cockknoker cockmaster cockmongler cockmongruel cockmonkey cockmuncher cocknose cocknugget cockshit cocksmith cocksmoker cocksniffer cocksucker cockwaffle coochie coochy coon cooter cracker cum cumbubble cumdumpster cumguzzler cumjockey cumslut cumtart cunnie cunnilingus cunt cuntass cuntface cunthole cuntlicker cuntrag cuntslut dago damn deggo dick dickbag dickbeaters dickface dickfuck dickfucker dickhead dickhole dickjuice dickmilk dickmonger dicks dickslap dicksucker dicksucking dickwad dickweasel dickweed dickwod dike dildo dipshit doochbag dookie douche douche douchebag douchewaffle dumass dumbass dumb-ass dumbfuck dumbshit dumshit dyke fag fagbag fagfucker faggits faggot faggotcock fagtard fatass fellatio feltch flamer fucks fuckass fuckbag fuckboy fuckbrain fuckbutt fucked fucker fuckersucker fuckface fuckhead fuckhole fuckin fucking fucknut fucknutt fuckoff fucks fuckstick fucktard fucktart fuckup fuckwad fuckwit fuckwitt fudgepacker gays gayass gaybob gaydo gayfuck gayfuckist gaylord gaytard gaywad goddamn goddamnit gooch gook gringo guido handjob hardon heeb homo homodumbshit honkey humping jackass jap jerkoff jigaboo jizz junglebunny jungle-bunny kike kooch kootch kooter kraut kunt kyke lameass lesbian lesbo lezzie mcfagget mick minge muthafucka muthafuckin mutherfucker mutherfucking mothafucka mothafuckin motherfucker motherfucking muthafucka muthafuckin mutherfucker mutherfucking muff muffdiver munging negro nigaboo nigga niggas nigger niggers nigletchild nutsack nutsack paki panooch pecker peckerhead penis penisfucker penispuffer piss pissed pissedoff pissflaps polesmoker pollock poon poonani poonany poontang porchmonkey porch-monkey prick punanny punta pussie pussy pussylicking puto queef queer queerbait queerhole renob rimjob ruski retard sandnigger sand-nigger schlong scrote shit shitass shitbag shitbagger shitbrains shitbreath shitcanned shitcunt shitdick shitface shitfaced shithead shithole shithouse shitspitter shitstain shitter shittiest shitting shitty shiz shiznit skank skeet skullfuck slut slutbag smeg snatch spic spick splooge spook suckass tard testicle thundercunt tit titfuck tits tittyfuck twat twatlips twats twatwaffle unclefucker va-j-j vag vagina vjayjay wank wetback whore whorebag whoreface loser hoe hobag hobag hoebag hoebag cuntlicker cuntlicker ho-bag hoe-bag titty titties niger niggers niggas assholes nigggers asssholes assshole nigggas niggga nigggers pu$$y pusssy sandnigga sandnigga sand-nigga fart fagget piss pissy muthafucker muthafuck cumshot cumshot butthole junglebunnie cumlicker cumlicker cumface cuntwhore whorecunt fagot faget fagat fagget faggot faggat buttmunch}
		@goodtags = lines.split.reject{|str|stop_words.include?(str)}
		@tagscount = @goodtags.uniq.count		
		
		
		if @tagscount < 3
			flash[:error] = "minimum of three tags are required [x] close"
		elsif @tagscount > 10
			#old way for taggings start
			#@goodtags = @goodtags.first(10)
			#@user.tag(@item, :with => @goodtags, :on => :tags)
			#		#@goodtags = @goodtags.to_s.gsub(" ",",") || ''
			#@item.save
			#old way for taggings end
			
			
			
							#only use unique values in array and first 10 values
							@goodtags = @goodtags.uniq.first(10)
							#remove current taggings
							@cleanouttags = User.find_by_sql(["DELETE FROM taggings WHERE taggable_id = ? AND taggable_type = ? AND context = ?", @item_id, "Item", "tags"])	
							
							
						
											   # goodtags array begin --
											   @goodtags.each do |goodtag| 
													@googy = @googy.to_s + "---" + goodtag.to_s
													
													 @newtag = goodtag.downcase.strip
													
													 @tagexists = Item.find_by_sql(["SELECT id FROM tags WHERE name = ? LIMIT 1", @newtag ])
													 if not @tagexists.empty?
													 
														#this if for when tag already exists in tags table
														@tagexistid = @tagexists[0].id
														
														#check to see if a taggings aleady exists, if not, add/insert a row
														@taggingexists = Item.find_by_sql(["SELECT id FROM taggings WHERE taggable_type = ? AND taggable_id = ? AND tag_id = ? LIMIT 1", "Item", @item_id, @tagexistid ])
														if not @taggingexists.empty?
															@taggingexistid = @taggingexists[0].id
														else
															#insert if tagging doesnt exist
															@inserttagging = Item.find_by_sql(["INSERT INTO taggings (tag_id, taggable_id, taggable_type, tagger_id, tagger_type, context, created_at) VALUES (?,?,?,?,?,?,?)", @tagexistid, @item_id, "Item", @current_user_id_for_check, "User", "tags", Time.now ])
														end
														
														
													 else
													 
														#this is for when tag doesnt exist in tags table
														@tagexistid = "not exist"
														#for this we need to add the tag first, then do insert because we know it doesnt exist
														#insert tag and get tag id
														@inserttag = User.find_by_sql(["INSERT INTO tags (name) VALUES (?)", @newtag ])
														# @inserttag = @inserttag.save
														#@tag = Tag.new(@newtag)

														@tagexistsnew = Item.find_by_sql(["SELECT id FROM tags WHERE name = ?", @newtag.strip.downcase ])
														#@tagexistsnew = Item.find_by_sql(["SELECT id FROM tags LIMIT 1"])
														@tagexistidnew = @tagexistsnew[0].id
														
														#insert tagging for new tag if it does not exist
														@taggingexists = User.find_by_sql(["SELECT id FROM taggings WHERE taggable_type = ? AND taggable_id = ? AND tag_id = ? LIMIT 1", "Filter", @item_id, @tagexistidnew.to_s ])
														if @taggingexists.empty?
															@inserttagging = Item.find_by_sql(["INSERT INTO taggings (tag_id, taggable_id, taggable_type, tagger_id, tagger_type, context, created_at) VALUES (?,?,?,?,?,?,?)", @tagexistidnew, @item_id, "Item", @current_user_id_for_check, "User", "tags", Time.now ])
														end
														
														
													 end
													
													
												end
											  # goodtags array begin --
			
			
			
			
			#below here is all good 
				#set update timestamp 
				@item.update_attribute(:updated_at, Time.now)
				#set title for url seo
				@item.update_attribute(:title, @goodtags.join("-"))			
				flash[:success] = "photo ad tags has been updated. only first ten tags were used [x] close"		
			## above here is all good
			
					
		elsif @tagscount > 2 && @tagscount < 11
		
			# old way for tagging start
			# @user.tag(@item, :with => @goodtags, :on => :tags)
			#		#@goodtags = @goodtags.to_s.gsub(" ",",") || ''
			#		@item.tag_list
			# @item.save
			
			
								#only use unique values in array
											@goodtags = @goodtags.uniq
											#remove current taggings
											@cleanouttags = User.find_by_sql(["DELETE FROM taggings WHERE taggable_id = ? AND taggable_type = ? AND context = ?", @item_id, "Item", "tags"])											
						
											   # goodtags array begin --
											   @goodtags.each do |goodtag| 
													@googy = @googy.to_s + "---" + goodtag.to_s
													
													 @newtag = goodtag.downcase.strip
													
													 @tagexists = Item.find_by_sql(["SELECT id FROM tags WHERE name = ? LIMIT 1", @newtag ])
													 if not @tagexists.empty?
													 
														#this if for when tag already exists in tags table
														@tagexistid = @tagexists[0].id
														
														#check to see if a taggings aleady exists, if not, add/insert a row
														@taggingexists = Item.find_by_sql(["SELECT id FROM taggings WHERE taggable_type = ? AND taggable_id = ? AND tag_id = ? LIMIT 1", "Item", @item_id, @tagexistid ])
														if not @taggingexists.empty?
															@taggingexistid = @taggingexists[0].id
														else
															#insert if tagging doesnt exist
															@inserttagging = Item.find_by_sql(["INSERT INTO taggings (tag_id, taggable_id, taggable_type, tagger_id, tagger_type, context, created_at) VALUES (?,?,?,?,?,?,?)", @tagexistid, @item_id, "Item", @current_user_id_for_check, "User", "tags", Time.now ])
														end
														
														
													 else
													 
														#this is for when tag doesnt exist in tags table
														@tagexistid = "not exist"
														#for this we need to add the tag first, then do insert because we know it doesnt exist
														#insert tag and get tag id
														@inserttag = User.find_by_sql(["INSERT INTO tags (name) VALUES (?)", @newtag ])
														# @inserttag = @inserttag.save
														#@tag = Tag.new(@newtag)

														@tagexistsnew = Item.find_by_sql(["SELECT id FROM tags WHERE name = ?", @newtag.strip.downcase ])
														#@tagexistsnew = Item.find_by_sql(["SELECT id FROM tags LIMIT 1"])
														@tagexistidnew = @tagexistsnew[0].id
														
														#insert tagging for new tag if it does not exist
														@taggingexists = User.find_by_sql(["SELECT id FROM taggings WHERE taggable_type = ? AND taggable_id = ? AND tag_id = ? LIMIT 1", "Item", @item_id, @tagexistidnew.to_s ])
														if @taggingexists.empty?
															@inserttagging = Filter.find_by_sql(["INSERT INTO taggings (tag_id, taggable_id, taggable_type, tagger_id, tagger_type, context, created_at) VALUES (?,?,?,?,?,?,?)", @tagexistidnew, @item_id, "Item", @current_user_id_for_check, "User", "tags", Time.now ])
														end
														
														
													 end
													
													
												end
											  # goodtags array begin --			
			
			
			
			
			
			
			
			
			
			
			
			#below here is all good 
				#set update timestamp 
				@item.update_attribute(:updated_at, Time.now)
				#set title for url seo
				@item.update_attribute(:title, @goodtags.join("-"))
				flash[:success] = "photo ad tags has been updated [x] close"
			## above here is all good
			
		end
		
		
     end
     
     
     if not params[:newprice].nil?
        @item.price = params[:newprice].gsub(/[^\d\.]/, '').to_i || ''
        @item.save
        
        #set update timestamp 
		@item.update_attribute(:updated_at, Time.now)
        flash[:success] = "photo ad price has been updated [x] close"
     end
     
     if not params[:newzipcode].nil?
		@newzipcode = params[:newzipcode].strip.gsub(/[^\d\.]/, '').to_i || ''
		@zipcode = Zipcode.find_by_sql(["SELECT id FROM zipcodes " +
		"WHERE zipcode = ? " +
		"LIMIT 1 ", @newzipcode.to_s]) 
		unless @zipcode.empty?
			@item.zipcode_id = @newzipcode
			@item.save
			
			#set update timestamp 
		    @item.update_attribute(:updated_at, Time.now)
			flash[:success] = "photo ad zip code has been updated [x] close"
		else
			flash[:error] = "invalid zip code. please try again [x] close"
		end
     
		 
		 
     end
     
			 #tweet new post if all fields are full
			 
			 itemistweeted = @item.tweeted.to_s
			 itemhasurl = @item.tinyurl.to_s
			 
			 if itemistweeted == 'N'
			 
				
				if not itemhasurl.empty?


						  #get tags to check
						  @tags = Item.find(params[:id]).tag_counts_on(:tags)
						  if @tags.empty? 
								   @tagsforitem = ""
						  else
							   @tags.each do |tag| 
										 if @tagsforitem.nil?
											@tagsforitem = ""+tag.name.to_s
										 else
											@tagsforitem = @tagsforitem.to_s+" "+tag.name.to_s
										 end
								  end
						  end 	
						  
						  #get price and zip code to check
						  @item = Item.find(params[:id])
						  tweetnewprice = @item.price.to_s
						  tweetnewzip = @item.zipcode_id.to_s
					  
						   

						   ## need to check if all data is there first
						   #if not @tagsforitem.nil? && tweetnewprice > "" && tweetnewzip > ""
						   if @tagsforitem.to_s.length > 6
						   
								if not tweetnewprice == ''
								
									if tweetnewzip.length == 5
								
										 # 7 + 9 = 16
										 # 140 - 16 - 1space = 125
										 
										 tinyurl = "fsp.lc/" + @item.tinyurl.to_s
										 tweet_desc = @tagsforitem.to_s + " for sale"
										 
										 if tweet_desc.length > 125 - tinyurl.length
										   tweet_desc = tweet_desc[0...(125 - tinyurl.length)] + '...'
										 end
										 
										 tweet = "#{tweet_desc} #{tinyurl}"
										 Twitter.update tweet
									
									#	flash[:success] = "#{tweet_desc} #{tinyurl}"
										 
										 @item.update_attribute(:tweeted, "Y")
										 @item.update_attribute(:tweeted_at, Time.now.utc)
										 
									end
										 
								end
							 
						   end
						   
						   
				end
			 
			 end
     
     
	 #redirect_to :back
	 redirect_to root_url+'items/'+params[:id]+'/edit'
    #render :action => "edit" 
      
  end

  def destroy
     @item.destroy
     @user = current_user
     #redirect_to :current_user
     redirect_to @user
  end
  
  def search
  
	@squery = params[:q].split(",")
    @title = "search for #" + params[:q] + " for sale "
    #create canonical url
    @rooturl  = "#{request.protocol}#{request.host_with_port}"
    canonical_url(@rooturl+'/search?q='+params[:q])
    @useragent = request.env["HTTP_USER_AGENT"]

	#	  def within_a_div
		#	index
	#	  end
   
	   # @micropost = Micropost.new if signed_in?
		if signed_in?
		  #@micropost = Micropost.new
		 # @feed_items = current_user.feed.paginate(:page => params[:page])
		  @item = Item.new
		end

	   #get records from users other than current user
	   if signed_in?
	   
		#@items = Item.find(:all, :conditions => ["user_id != ?", current_user.id])
		#@items = Item.find(:all, :conditions => ["user_id != ? AND flagged = ?", current_user.id, "N"]).paginate(:per_page => 20, :page => params[:page])
		
		
		@items = Item.tagged_with([@squery], :any => true).paginate(:per_page => 16, :page => params[:page])	
	  
	   else
		#show all items
		#@items = Item.find(:all)
			#@items = Item.find(:all, :conditions => ["flagged = ?", "N"]).paginate(:per_page => 20, :page => params[:page])
			
			
			@items = Item.tagged_with([@squery], :any => true).paginate(:per_page => 16, :page => params[:page])	
			
			if request.xhr?
			  sleep(3) # make request a little bit slower to see loader :-)
			  render :partial => @items
			end
	   end

	
  
	render 'pages/home'
  
  
  end
  
  
  
  
  def sold
  
     if params[:item_id].nil?
     else
         @item = Item.find(params[:item_id])
         @item.is_sold = 'Y'
         @item.save
     end 
	respond_to do |format|
	  format.html { redirect_to :back }
	  format.js
	end
  
  	  if signed_in?
		 @item = Item.new
	  end
  
  end
  
  def unsold
  
     if params[:item_id].nil?
     else
         @item = Item.find(params[:item_id])
         @item.is_sold = 'N'
         @item.save
     end 
	respond_to do |format|
	  format.html { redirect_to :back }
	  format.js
	end


  	  if signed_in?
		 @item = Item.new
	  end
  
  end
  
  def feed
  
	  # this will be the name of the feed displayed on the feed reader
	  @title = "forsalephoto feed"

	  # the items
	  ##@items = Item.order("updated_at desc")
	  @items = Item.find_by_sql(["SELECT * FROM items " +
		"WHERE is_sold = ? AND flagged = ? ORDER BY updated_at DESC LIMIT 500", "N", "N"]) 

	  # this will be our Feed's update timestamp
	  @updated = @items.first.updated_at unless @items.empty?

	  respond_to do |format|
		format.atom { render :layout => false }

		# we want the RSS feed to redirect permanently to the ATOM feed
		format.rss { redirect_to feed_path(:format => :atom), :status => :moved_permanently }
	  end
	  
   end  
   

  
  
 
  private

	def authorized_user
	  @item = current_user.items.find(params[:id])
	rescue
	  redirect_to root_path
	end  
	
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
