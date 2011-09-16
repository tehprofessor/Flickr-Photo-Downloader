require 'rubygems'
require 'fleakr'

Fleakr.api_key = "YER_API_KEY"

###############################################
# Flickr Downloader v. 0.1
###############################################
#
# This software is released under the MIT license
# where applicable (not another entity's code).
# 
# This is REALLY simple, but effective, flickr downloader
# You can download by: (a) tags or (b) group (through users)
# It will create a directroy with the name of the tag or group
# and place the photos there. There is no option to write by
# filename. You'll need to uncomment the method you wish to use
# before you run the script. (scroll to the bottom)

# HOW TO USE:

#
# Follow the prompts... When it asks to CONTINUE, just press enter. If something is wrong,
# issue an interrupt with ctrl+c to stop the script. I'm using gets just to pause incase
# it's not doing what you expected. Your input means nothing ;)
#

# 
# # TAGS
#
# To download a tag's first 100 photos, simply uncomment
# line #90: 
#
#    Line 129 (before): #find_and_download
#    Line 129  (after):  find_and_download
#
# Then, run the script:
# 
#    ruby download-flickr-photos.rb
# 
# Then type in the tags seperated by commas
#
#    space, hipsters, beer, girls with cigarettes
#
# Then wait!
#

#
# # GROUPS
# 
# Fleakr doesn't support finding by group ID (or I didn't see the option)
# so you must access the group through a Flickr user.
# Simply uncomment line 125:
#
#    Line 130 (before): #group_download
#    Line 130  (after):  group_download
#
# Then, run the script:
# 
#    ruby download-flickr-photos.rb
#
# It will ask you for the username and
# group name EXACTLY as it appears on flickr.
#

def group_download
  
  @time = Time.now
  puts "Please enter the username with the group you'd like to download photos from:"
  @user = gets
  @user = @user.chomp!
  @user = Fleakr.user("#{@user}")
  puts "Please put the name of the group, EXACTLY how it appears on flickr:"
  @group = gets
  @group = @group.chomp!
  @user.groups.each {|g| if g.name == "#{@group}" then puts "Winner" && @group = g end }
  @groups.each do |group|
    puts "Making directory"
    @g_name = group.name.split(" ").map!{|g| g.capitalize }.join("")
    puts "#{@g_name}"
    dir = %x( mkdir #{@g_name} )
    puts "created: #{@g_name}"
    puts "Continue?"
    @tmp = gets
    group.photos.each do |photo|
      @t_start = Time.now
      if photo.original
         photo.original.save_to("#{@g_name}")
        puts "Saved #{@p_name}"
      elsif photo.large
         photo.large.save_to("#{@g_name}")
        puts "Saved #{@p_name}"
      else
        puts "No sizes large enough"
      end
      @t_end = Time.now
      @total = @t_end - @t_start
      puts "title: #{photo.title}"
      puts "downloaded in: #{@total}"
    end
  end
  @endtime = Time.now
  @total = @endtime - @time
  puts "Total time: #{@total}"
end

def find_and_download
  @time = Time.now
  
  puts "Please enter the search terms you'd like to download photos for:"
  puts "(comma seperated)"
  @search = gets
  @search = @search.split(",").map!{|g| g.chomp }
  @search.each do |search|
    puts "Searching: #{search}"
    @photos = Fleakr.search(:tags => search)
    puts "Downloading..."
    @photos.each do |photo|
      @t_start = Time.now
      if photo.original
        photo.original.save_to('flickr')
        puts "Saved #{photo.title}"
      elsif photo.large
        photo.large.save_to('flickr')
        puts "Saved #{photo.title}"
      else
        puts "No sizes large enough"
      end
      @t_end = Time.now
      @total = @t_end - @t_start
      puts "title: #{photo.title}"
      puts "downloaded in: #{@total}"
    end
  end
  @endtime = Time.now
  @total = @endtime - @time
  puts "Total time: #{@total}"
end

# find_and_download
# group_download