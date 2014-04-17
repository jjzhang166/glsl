#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec4 mouse;
uniform sampler2D tex0;
uniform sampler2D tex1;

void main(void)
{
float scale = 1.0;
vec2 center = vec2(0.5,0.5);
vec2 z, c;
vec4 out_Color;
	int iter;
	float it = 0.0;
	
c.x = (gl_PointCoord.x - 0.5) * scale - center.x; //I did try the 1.33* as the article uses, though I have no idea why it was there and other articles' sources had nothing similar so I have been trying without it
c.y = (gl_PointCoord.y - 0.5) * scale - center.y;
z = c;
out_Color = vec4(1.0, 0.0, 0.0, 1.0);
for(int i = 0; i < 20; i ++){
	float x = (z.x * z.x - z.y * z.y) + c.x;
	float y = (z.y * z.x + z.x * z.y) + c.y;
	if((x*x + y*y) > 4.0){  
		it = float(i)/20.0;
		out_Color = vec4(0.0, 1.0, 0.0, 1.0);  
  		break;  
	}  
	z.x = x;  
	z.y = y;  
}
gl_FragColor = it*out_Color; //vec4(vec3(it),1); //texture2D(tex0,vec2(ii));
}
