package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = 1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];

	private static var creditsStuff:Array<Dynamic> = [ //Name - Icon name - Description - Link - BG Color
		['Psych Engine Team'],
		['Shadow Mario',		'shadowmario',		'Main Programmer of Psych Engine',					'https://twitter.com/Shadow_Mario_',		0xFF000000],
		['RiverOaken',			'shadowmario',		'Main Artist/Animator of Psych Engine',				'https://twitter.com/river_oaken',			0xFF000000],
		[''],
		['Engine Contributors'],
		['shubs',				'shadowmario',			'New Input System Programmer',						'https://twitter.com/yoshubs',			0xFF000000],
		['PolybiusProxy',		'shadowmario',	'.MP4 Video Loader Extension',						'https://twitter.com/polybiusproxy',			0xFF000000],
		['gedehari',			'shadowmario',			'Chart Editor\'s Sound Waveform base',				'https://twitter.com/gedehari',			0xFF000000],
		['Keoiki',				'shadowmario',			'Note Splash Animations',							'https://twitter.com/Keoiki_',			0xFF000000],
		['SandPlanet',			'shadowmario',		'Mascot\'s Owner\nMain Supporter of the Engine',		'https://twitter.com/SandPlanetNG',		0xFF000000],
		['bubba',				'shadowmario',		'Guest Composer for "Hot Dilf"',	'https://www.youtube.com/channel/UCxQTnLmv0OAS63yzk9pVfaw',	0xFF000000],
		[''],
		["Funkin' Crew"],
		['ninjamuffin99',		'shadowmario',	"Programmer of Friday Night Funkin'",				'https://twitter.com/ninja_muffin99',			0xFF000000],
		['PhantomArcade',		'shadowmario',	"Animator of Friday Night Funkin'",					'https://twitter.com/PhantomArcade3K',			0xFF000000],
		['evilsk8r',			'shadowmario',			"Artist of Friday Night Funkin'",					'https://twitter.com/evilsk8r',			0xFF000000],
		['kawaisprite',			'shadowmario',		"Composer of Friday Night Funkin'",					'https://twitter.com/kawaisprite',			0xFF000000],
		[''],
		["Hypno's Lullaby Team"],
		['Banbuds',				'shadowmario',		"Director, Artist, Animator, and Voice Actor",			'https://twitter.com/banbuds',			0xFF000000],
		['Ash',					'shadowmario',		"Programmer",										'https://twitter.com/ash__i_guess_',		0xFF000000],
		['Oh wow its shubs again',		'shadowmario',	"Programmer",					'https://twitter.com/yoshubs',			0xFF000000],
		['Adam McHummus',			'shadowmario',		"Composer",					'https://twitter.com/mchummus',			0xFF000000],
		['The Innuendo',			'shadowmario',		"Composer",			'https://twitter.com/TheInnuend0',			0xFF000000],
		['Nimbus Cumulus',			'shadowmario',		"Composer",						'https://nimbuscumulus.newgrounds.com/',		0xFF000000],
		['Uncle Joel',	'shadowmario',	"Artist and Animator",					'https://twitter.com/Joel_Masada',			0xFF000000],
		['chillinraptor',			'shadowmario',		"Artist BG",					'https://twitter.com/ChillinRaptor',			0xFF000000],
		['ScorchVx',				'shadowmario',		"Artist",			'https://twitter.com/ScorchVx',			0xFF000000],
		['Hello Again Sandplanet',					'shadowmario',		"Charter",				'https://twitter.com/SandPlanetNG',		0xFF000000],
		['Fidy50',					'shadowmario',	"Charter",					'https://www.youtube.com/channel/UCgjhVE5MBsg3DObEE42WfDQ',			0xFF000000],
		['Typic',			'shadowmario',		"Artist and Animator",					'https://twitter.com/typicalemerald',			0xFF000000],
		['Mr NoL',			'shadowmario',		"Vocal Edits",			'https://www.youtube.com/channel/UC89Ia9-bOY4XN0oyfRFOjSQ',			0xFF000000],
		['BonesTheSkelebunny01',			'shadowmario',		"Artist",						'',		0xFF000000],
		['fueg0',	'shadowmario',	"Mac Port",					'',			0xFF000000],
		[''],
		["Easter Egg Edition"],
		['PixelAves',				'shadowmario',		"Sprites, Music Remixes, Code",			'https://twitter.com/banbuds',			0xFF000000],
		['my sister',					'shadowmario',		"actually knows how to code",										'',		0xFF000000],
		['Detective Pyro',		'shadowmario',	"Voice Actor (I'M COLD)",					'https://gamebanana.com/members/1447511',			0xFF000000]
	];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			if(isSelectable) {
				optionText.x -= 70;
			}
			optionText.forceX = optionText.x;
			//optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(isSelectable) {
				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
			}
		}

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		bg.color = creditsStuff[curSelected][4];
		intendedColor = bg.color;
		changeSelection();
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
		if(controls.ACCEPT) {
			CoolUtil.browserLoad(creditsStuff[curSelected][3]);
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:Int = creditsStuff[curSelected][4];
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}
		descText.text = creditsStuff[curSelected][2];
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}
