package dashboard;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import systems.InputHandler;

/**
 * ...
 * @author ...
 */
class Dashboard extends FlxGroup
{
	public var background:FlxSprite;
	private var controls:ControlsContainer;
	private var inputHandler:InputHandler;
	private var selected:FlxSprite;
	
	public function new(x:Int, y:Int, inputH:InputHandler) 
	{
		super();
		inputHandler = inputH;
		background = new FlxSprite(x, y);
		background.loadGraphic("assets/images/dashBG.png");
		controls = new ControlsContainer(y);
		
		selected = new FlxSprite();
		selected.scale.set(4, 4);
		selected.updateHitbox();
		selected.x = 58;
		selected.y = y;
		
		add(background);
		add(controls);
		add(selected);
	}
	
	public function setSelected(sprite:FlxSprite)
	{
		selected.loadGraphicFromSprite(sprite);
		selected.animation.frameIndex = sprite.animation.frameIndex;
	}
}