import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.utils.Data;

class Main extends Engine
{
    public static inline var kScreenWidth:Int = 420;
    public static inline var kScreenHeight:Int = 800;
    public static inline var kFrameRate:Int = 60;

    public function new()
    {
        super(kScreenWidth, kScreenHeight, kFrameRate, false);
    }

    override public function init()
    {
        HXP.defaultFont = "font/Dalek.ttf";
        
    #if !mobile
    //    #if flash
    if (flash.system.Capabilities.isDebugger)
    //    #end
    {
    HXP.console.enable();
    }
    #end
        HXP.screen.scale = 1;
        HXP.scene = new TitleScene();
        Data.load("saveHighScore");
    }

    public static function main()
    {
        var app = new Main();
    }
}