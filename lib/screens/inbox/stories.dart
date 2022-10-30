
//>>>>>>>>>>> also, the most bothering bug, I need to fix the fact that VideoPlayer controller is not being
// initialized when it is supposed to. I need to be able to wait for it to be initialized before displaying anythig on the
// screen........... I think we can solve this error using Future builder

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_up/model/storyModel.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// When you are done, add the one for audio and text... Let's hope it's not too hard

// research on the use of the singleTickerProvideStateMixin. It is mostly used for tab bars, now, its used for page view
// alson research on the use for the global position dx and its uses and the video controller at large
// singleTickerProvideStateMixin I think this is used when one page is being animated at a time

class Stories  extends StatefulWidget{
 const Stories({Key? key, required this.storyItems}) : super(key: key);
  final List<StoryModel> storyItems;
  State<Stories> createState()=> _Stories();
}

// Single ticker is being used because the page is going to be built one at a time
class _Stories extends State<Stories> with SingleTickerProviderStateMixin{

  late PageController _pageController;
  late VideoPlayerController _videoPlayerController;
  late AnimationController _animationController;
  int currentIndex = 0;

  @override 
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    // _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    _pageController = PageController();
    // _videoPlayerController.initialize();
    _animationController = AnimationController(vsync: this);

    //>>>>>>>>>>>>>>>>>>>>>>>>>> research on this and the whole of the animation controller

    // This place listens to how far the animation has gone and makes adjustments due to that
    _animationController.addStatusListener((status) {

      // if status is completed, the animation stops and resets
      // then the next story is loaded and the count increases
      
      if(status == AnimationStatus.completed){
        _animationController.stop();
        _animationController.reset();
        setState(() {
          if(currentIndex + 1 < widget.storyItems.length){
            currentIndex += 1;
            _loadStory(widget.storyItems[currentIndex]);
          }
          else{
            // any other story operation here returns the out of bound error
            //>>>>>>>>>>>>>>>>>>>>You have to either use the navigator.of(context).pop here
            // or loop story by setting current index back to 0
            Navigator.pop(context);
            currentIndex = 0;
            // _loadStory(widget.storyItems[currentIndex]);
          }
        });
      }
     });

    // would love to know why the video player instantiation was replaced with the load story

    // _videoPlayerController = VideoPlayerController.network(widget.storyItems[2].url)
    // ..initialize().then((value) => setState((){}));
    // _videoPlayerController.play();

    final StoryModel firstStory = widget.storyItems.first;
    _loadStory( firstStory, animateToPage: false);
  }

  @override 
  Widget build(BuildContext context ){
    final StoryModel story = widget.storyItems[currentIndex];
    return Scaffold(
      backgroundColor: Colors.black,

      // we used the Pageview.builder to make the content fill up the entire screen
      // for different gesture to perform different stuffs, we wrap the entire widget in a gesture detector

      body: GestureDetector(

        // OnTapDown is used instead of on Tap because we need tap down details to know when the user taps on the screen
        // the _onTapDown() function controls the actions that happens anytime the whole screen is being tapped on
        onTapDown: ((details) => _onTapDown(details, story)),
        child: Stack(
          children: <Widget>[

            // Page view. builder builds the page dynamically
            // loads the contents based on what the user specifies
            PageView.builder(
            controller: _pageController, 
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.storyItems.length,
            itemBuilder: (context, index){
                final StoryModel story = widget.storyItems[index];
                if(story.media == MediaType.image){
                  return CachedNetworkImage(
                    imageUrl: story.url,
                    fit: BoxFit.cover,);
                }
                else if(story.media == MediaType.video){
                  if( _videoPlayerController.value.isInitialized){
                    return FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _videoPlayerController.value.size.width,
                        height: _videoPlayerController.value.size.height,
                        child: VideoPlayer(_videoPlayerController),
                      ),
                    );
                  }
                }
              return const SizedBox.shrink();
            }
            ),

            // this place is the piece of code that controls the indicator bar at the top of the status page
            Positioned(
              top: 40,
              left: 10,
              right: 10,
              child: Row(

                // children of the row widget is built dynamically based on what was passed into the page view 
                //builder
                children: widget.storyItems
                .asMap()
                .map((index, e) {
                  // come back to this place and debug so you dont carry errors into a production app
                  return MapEntry(index, AnimatedBar(
                    animController: _animationController,
                    position: index,
                    currentIndex: currentIndex
                  ));
                }).values.toList()
              ),
            )
          ]
        ),
      ),
    );
  }

  // the tap down method
  // we want to separate our screen into 3

  // what ever functionality given to the taps of the screen is created and being adjusted here
  // update this part to change the tap fuctionality
  void _onTapDown(TapDownDetails details, StoryModel story){
    final double screenWidth = MediaQuery.of(context).size.width;

    // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> research on this place
    final double dx = details.globalPosition.dx;
    if(dx< screenWidth/3){
      setState(() {
        if(currentIndex - 1 >=0){
          currentIndex -= 1;
          _loadStory( widget.storyItems[currentIndex]);
        }
      });
    }
    else if(dx>  2 * screenWidth/3){
      setState(() {
        if(currentIndex + 1 <widget.storyItems.length){
          currentIndex += 1;
          _loadStory( widget.storyItems[currentIndex]);
        }

        else{
          // anything in this else returns the out of bound error 
          //>>>>>>>>>>>>>>>>>>>>and you have to either navigator.pop here or loop story
          Navigator.pop(context);
          currentIndex = 0;
          _loadStory( widget.storyItems[currentIndex]);
        }
      });
    }
    else{
      if(story.media == MediaType.video){
        if(_videoPlayerController.value.isPlaying){
          _videoPlayerController.pause();
          _animationController.stop();
        }
      }
      else{
        _videoPlayerController.play();
        _animationController.forward();
      }
    }
  }

  // the load story method to load the next story
  void _loadStory(StoryModel? story, { bool animateToPage = true}) {
    // this value helps us to manipulate the length of the progres
    _animationController.stop();
    _animationController.reset();

    if(story?.media == MediaType.image){
      _animationController.duration = story?.duration;
      _animationController.forward();
    }
    else if(story?.media == MediaType.video){

      // _videoPlayerController = null;
      _videoPlayerController.dispose();
      _videoPlayerController = VideoPlayerController.network(story!.url)
      ..initialize().then((value) => setState((){}));
      if(_videoPlayerController.value.isInitialized){
        _animationController.duration = _videoPlayerController.value.duration;
        _videoPlayerController.play();
        _animationController.forward();
      }

      // else if(_videoPlayerController.value.hasError){

      // }
    }
    

    if(animateToPage){
      _pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeOut);
    }
  }
  
}


///////////// Omo go over this class again and check what each every of the code does

//This part of the code creates a single bar and its properties
// to change how the loading bar is going to be, come here for that
// would love to change the time that the bar animate dynamically  
class AnimatedBar extends StatelessWidget{
  const AnimatedBar({Key? key, required this.animController,
  required this.position,
  required this.currentIndex}): super(key: key);

  final AnimationController animController;
  final int position;
  final int currentIndex;

  @override 
  Widget build(BuildContext context){
    return Flexible(child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.5),
      child: LayoutBuilder(
        builder: (context, constraints){
          return Stack(
            children: <Widget>[
              _buildContainer(
                double.infinity,
                position < currentIndex?Colors.white 
                : Colors.white.withOpacity(0.5)
              ),
              position == currentIndex? 
              
              AnimatedBuilder(
                animation: animController,
                builder: ((context, child) {
                  print(">>>>>>>>>>animated controller value is ${animController.value}");
                  return _buildContainer(
                    
                    constraints.maxWidth * animController.value,
                    Colors.white
                  );
                }))
                
                :const SizedBox.shrink()
            ],
          );
        }),
    ));
  }

  Container _buildContainer(double width, Color color){
    return Container(
      height: 5,
      width: width,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.black26,
          width: 0.8
        ),
        borderRadius: BorderRadius.circular(3)
      ),
    );
  }
}