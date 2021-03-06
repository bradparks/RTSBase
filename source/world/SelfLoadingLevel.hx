package world;

import flash.geom.ColorTransform;
import flixel.FlxSprite;
import haxe.Json;
import world.TiledTypes.Layer;
import world.TiledTypes.TiledLevel;
import flixel.FlxG;
import openfl.Assets;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import openfl.display.BitmapData;
import adapters.TwoDSprite;
import flixel.graphics.frames.FlxTileFrames;

/**
 * ...
 * @author John Doughty
 */
class SelfLoadingLevel 
{
	//public var nodes:Array<Node> = [];
	public var width:Int;
	public var height:Int;
	public var highlight:TwoDSprite;
	
	public var tiledLevel(default,null):TiledLevel;
	public var background:TwoDSprite;
	private var fog:TwoDSprite;
	private var selectedNode:Node;
	
	public function new(json:String) 
	{
		var i:Int = 0;
		var j:Int = 0;
		var tileSetId:Int = 0;
		
		var asset:String = "";
		var frame:Int = 0;
		var x:Int = 0;
		var y:Int = 0;
		var pass:Bool = false;
		
		var graphicLayer:Layer = null;
		var collisionLayer:Layer = null;
		var sprites:Array<FlxSprite>;
		var sourceRect:Rectangle = new Rectangle(0, 0, 0, 0);
		var destPoint:Point = new Point(0, 0);
		
		tiledLevel = Json.parse(json);
		sprites = [new FlxSprite().loadGraphic("assets/" + tiledLevel.tilesets[tileSetId].image.substring(3), true, tiledLevel.tilewidth, tiledLevel.tileheight)];
		var sourceRect:Rectangle = new Rectangle(0, 0, tiledLevel.tilewidth, tiledLevel.tileheight);
		var destPoint:Point = new Point(0, 0);
		
		width = tiledLevel.width;
		height = tiledLevel.height;
		background = new TwoDSprite();
		background.pixels = new BitmapData(Std.int(width * tiledLevel.tilewidth), height * tiledLevel.tileheight, true, 0xFFFFFFFF);
		FlxG.state.add(background);
		fog = new TwoDSprite();
		fog.pixels = new BitmapData(Std.int(width * tiledLevel.tilewidth), height * tiledLevel.tileheight, true, 0xFFFFFFFF);
		FlxG.state.add(fog);
		for (i in 0...tiledLevel.layers.length)
		{
			if (tiledLevel.layers[i].name == "graphic")
			{
				graphicLayer = tiledLevel.layers[i];
			}
			else if (tiledLevel.layers[i].name == "collision")
			{
				collisionLayer = tiledLevel.layers[i];
			}
			if (graphicLayer != null && collisionLayer != null)
			{
				for (i in 0...graphicLayer.data.length)
				{
					tileSetId = 0;
					for (j in 0...(tiledLevel.tilesets.length-1))
					{
						if (graphicLayer.data[i] > tiledLevel.tilesets[j + 1].firstgid)
						{
							tileSetId += 1;
							if (tileSetId == sprites.length)
							{
								sprites.push(new FlxSprite());
								sprites[tileSetId].loadGraphic("assets/" + tiledLevel.tilesets[tileSetId].image.substring(3), true, tiledLevel.tilewidth, tiledLevel.tileheight);
							}
						}
					}
					asset = "assets/" + tiledLevel.tilesets[tileSetId].image.substring(3);
					frame = graphicLayer.data[i] - tiledLevel.tilesets[tileSetId].firstgid;
					x = i % width;
					y = Math.floor(i / width);
					pass = collisionLayer.data[i] == 0;
					Node.activeNodes.push(new Node(tiledLevel.tilewidth,tiledLevel.tileheight, x, y, pass));
					
					destPoint.x = Node.activeNodes[i].x;
					destPoint.y = Node.activeNodes[i].y;
					
					sprites[tileSetId].animation.frameIndex = frame;
					background.pixels.copyPixels(sprites[tileSetId].updateFramePixels(), sourceRect, destPoint, null, null, true);
					background.dirty = true;
				}
				Node.createNeighbors(width, height);
				break;
			}
			for (i in 0...tiledLevel.tilesets.length)
			{
				if (tiledLevel.tilesets[i].name == "highlight")
				{
					highlight = new TwoDSprite(0, 0, "assets/"+tiledLevel.tilesets[i].image.substring(3), tiledLevel.tilewidth, tiledLevel.tileheight);
					highlight.addAnimation("main", [0, 1, 2, 3, 4, 5, 6], 18);//has to be better way
					highlight.playAnimation("main");
				}
			}
		}
	}
	
	public function rebuildFog()
	{
		
		fog.pixels.dispose();
		fog.pixels = new BitmapData(Std.int(width * tiledLevel.tilewidth), height * tiledLevel.tileheight, true, 0x66000000);
		for (i in 0...Node.activeNodes.length)
		{
			if (!Node.activeNodes[i].overlayShadowOn)
			{
				var sourceRect:Rectangle = new Rectangle(Node.activeNodes[i].x, Node.activeNodes[i].y, Node.activeNodes[i].width, Node.activeNodes[i].height);
				var destPoint:Point = new Point(Std.int(Node.activeNodes[i].x), Node.activeNodes[i].y);
				fog.pixels.copyPixels(background.pixels, sourceRect, destPoint, background.pixels, new Point(0,0), false);
			}
		}
		fog.dirty = true;
		
	}
}