package actors;

import flixel.FlxSprite;
import flixel.FlxG;
import world.Node;

/**
 * ...
 * @author John Doughty
 */
class BaseActor extends FlxSprite
{

	var selected:Bool = false;
	
	public function new(node:Node) 
	{
		super(node.x, node.y);
		node.setOccupant(this);
		
	}
	
	public function select():Void
	{
		color = 0xdddddd;
		selected = true;
	}
	
	public function resetSelect():Void
	{
		selected = false;
		color = 0xffffff;
	}
	override public function update():Void 
	{
		super.update();
		move();
	}
	
	@:extern inline private function isMoveKeyDown():Bool
	{
		return FlxG.keys.anyPressed(["LEFT", "A", "RIGHT", "D", "Up", "W", "Down", "S"]);
	}
	
	public function move()
	{
		if (isMoveKeyDown())
		{
			if (FlxG.keys.anyPressed(["LEFT", "A"]))
			{
				x -= 8;
				set_flipX(true);
			}
			else if (FlxG.keys.anyPressed(["RIGHT", "D"]))
			{
				x += 8;
				set_flipX(false);
			}

			if (FlxG.keys.anyPressed(["Up", "W"]))
			{
				y -= 8;
			}
			else if (FlxG.keys.anyPressed(["Down", "S"]))
			{
				y += 8;
			}
		}
	}
}