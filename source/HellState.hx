import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextFormatMarkerPair;
import flixel.util.FlxColor;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.tweens.FlxTween;

class HellState extends MusicBeatState
{
	var congratsText:FlxText;
    var nextState:FlxState;
	public function new(stateTo:FlxState)
	{
		super();
        nextState = stateTo;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		var redFormat = new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.RED, true, true), '^');

		congratsText = new FlxText(0, 0, FlxG.width,
			"Congrats!\nyou beat Hell Mode\nyou ^fucking^ maniac\n\nNow you get an even harder challenge\ngo check your options menu.",
			32);
			
        congratsText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		congratsText.screenCenter();
		congratsText.applyMarkup(congratsText.text, [redFormat]);
		add(congratsText);
	}

    var leaving:Bool = false;

	override function update(elapsed:Float)
	{
		if(!leaving) {
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) {
				leaving = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				FlxG.save.data.hasUnlockedFuck = true;
                FlxG.save.flush();
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTween.tween(congratsText, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
						MusicBeatState.switchState(nextState);
					}
				});
			}
		}
		super.update(elapsed);
	}
}
