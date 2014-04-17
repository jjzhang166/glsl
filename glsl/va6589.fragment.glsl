#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
//Simple raymarching sandbox with camera

//Raymarching Distance Fields
//About http://www.iquilezles.org/www/articles/raymarchingdf/raymarchingdf.htm
//Also known as Sphere Tracing
//Original seen here: http://twitter.com/#!/paulofalcao/statuses/134807547860353024



void main(void){

  vec2 UV=gl_FragCoord.xy;


	float posx=0.0,posy=0.0;	
	for(int i=0; i<2; i++){
		float unidad=1.0/pow(3.0,float(i+1));
		//if(UV.x>unidad && UV.x<unidad+0.01) color=vec4(1,0,0,1);
		//if(UV.y>unidad && UV.y<unidad+0.01) color=vec4(1,0,0,1);
		for(float x=0.; x<1.; x += 0.333){
			for(float y=0.; y<1.; y+=0.333){
				if(UV.x>posx+unidad && UV.x<posx+2.*unidad && UV.y>posy+unidad && UV.y<posy+2.*unidad){
					gl_FragColor=vec4(1,0,0,1);
				}
				if(UV.x>x && UV.x<x+unidad && UV.y>y && UV.y<y+unidad){
					posx=x;
					posy=y;
					//color=vec4(x,y,0,1);
				}
			}
		}

	}
	
	
}