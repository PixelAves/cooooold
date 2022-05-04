import flixel.graphics.FlxGraphic;
import sys.thread.Thread;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;

enum PreloadType {
    atlas;
    image;
}

class PreloadState extends FlxState {

    var globalRescale:Float = 2/3;
    var preloadStart:Bool = false;

    var loadText:FlxText;
    var assetStack:Map<String, PreloadType> = [
        'death/gf_gameover_sprite' => PreloadType.image, 
        'death/hypnos_grabby_grabby' => PreloadType.image, 
        'death/forest' => PreloadType.image, 
        'death/retry' => PreloadType.image, 
        ///*
        'hypno/Hypno bg background' => PreloadType.image, 
        'hypno/Hypno bg midground' => PreloadType.image, 
        'hypno/Hypno bg foreground' => PreloadType.image,
        'hypno' => PreloadType.atlas,
        /*
        'gf' => PreloadType.atlas,
        'hypno-two' => PreloadType.atlas,
        */
    ];
    var maxCount:Int;

    public static var preloadedAssets:Map<String, FlxGraphic>;
    var backgroundGroup:FlxTypedGroup<FlxSprite>;
    var bg:FlxSprite;

    public static var unlockedSongs:Array<Bool> = [false, false];

    override public function create() {
        super.create();

        FlxG.camera.alpha = 0;

        maxCount = Lambda.count(assetStack);
        trace(maxCount);
        // create funny assets
        backgroundGroup = new FlxTypedGroup<FlxSprite>();
        FlxG.mouse.visible = false;

        preloadedAssets = new Map<String, FlxGraphic>();

		var gfBg:FlxSprite = new FlxSprite();
			if (FlxG.random.int(0, 10) == 1)
				gfBg.loadGraphic(Paths.image('ort'));
			else if (FlxG.random.int(0, 10) == 2)
				gfBg.loadGraphic(Paths.image('ort'));
			else if (FlxG.random.int(0, 10) == 3)
				gfBg.loadGraphic(Paths.image('this was fun to draw'));
			else
				gfBg.loadGraphic(Paths.image('Loading Blake'));
        gfBg.setGraphicSize(Std.int(gfBg.width * globalRescale));
        gfBg.updateHitbox();
		backgroundGroup.add(gfBg);

        var pendulum:FlxSprite = new FlxSprite();
        pendulum.frames = Paths.getSparrowAtlas('Loading Screen Pendelum');
        pendulum.animation.addByPrefix('load', 'Loading Pendelum Finished', 24, true);
        pendulum.animation.play('load');
        pendulum.setGraphicSize(Std.int(pendulum.width * globalRescale));
        pendulum.updateHitbox();
        backgroundGroup.add(pendulum);
        pendulum.x = FlxG.width - (pendulum.width + 10);
        pendulum.y = FlxG.height - (pendulum.height + 10);

        add(backgroundGroup);
        FlxTween.tween(FlxG.camera, {alpha: 1}, 0.5, {
            onComplete: function(tween:FlxTween){
                Thread.create(function(){
                    assetGenerate();
                });
            }
        });

        // save bullshit
        FlxG.save.bind('funkin', 'ninjamuffin99');
        if(FlxG.save.data != null) {
            if (FlxG.save.data.silverUnlock != null)
                unlockedSongs[0] = FlxG.save.data.silverUnlock;
            if (FlxG.save.data.missingnoUnlock != null)
                unlockedSongs[1] = FlxG.save.data.missingnoUnlock;
            if (FlxG.save.data.hasUnlockedFuck == null)
                FlxG.save.data.hasUnlockedFuck = false;
        }

        loadText = new FlxText(5, FlxG.height - (32 + 5), 0, 'Loading...', 32);
		loadText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(loadText);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
    }

    var storedPercentage:Float = 0;

    function assetGenerate() {
        //
        var countUp:Int = 0;
        for (i in assetStack.keys()) {
            trace('calling asset $i');

            FlxGraphic.defaultPersist = true;
            switch(assetStack[i]) {
                case PreloadType.image:
                    var savedGraphic:FlxGraphic = FlxG.bitmap.add(Paths.image(i, 'shared'));
                    preloadedAssets.set(i, savedGraphic);
                    trace(savedGraphic + ', yeah its working');
                case PreloadType.atlas:
                    var preloadedCharacter:Character = new Character(FlxG.width / 2, FlxG.height / 2, i);
                    preloadedCharacter.visible = false;
                    add(preloadedCharacter);
                    trace('character loaded ${preloadedCharacter.frames}');
            }
            FlxGraphic.defaultPersist = false;
        
            countUp++;
            storedPercentage = countUp/maxCount;
            loadText.text = 'Loading... Progress at ${Math.floor(storedPercentage * 100)}%';
        }

        ///*
        FlxTween.tween(FlxG.camera, {alpha: 0}, 0.5, {
            onComplete: function(tween:FlxTween){
                FlxG.switchState(new TitleState());
            }
        });
        //*/

    }
}