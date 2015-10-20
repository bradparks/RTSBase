package actors;
import flixel.FlxG;
import world.Node;

/**
 * ...
 * @author John Doughty
 */
class SwordSoldier extends BaseActor
{

	public function new(node:Node) 
	{
		super(node);
		loadGraphic("assets/images/soldiers.png", true, 8, 8);
		animation.add("active", [0, 1], 5, true);
	}
	
	override private function takeAction()
	{
		super.takeAction();
		if (moving)
		{
			animation.play("active");
		}
		else
		{
			animation.frameIndex = 0;
			animation.pause();
		}
	}
	
}