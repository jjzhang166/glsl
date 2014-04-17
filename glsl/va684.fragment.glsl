#ifdef GL_ES
precision mediump float;
#endif

//Edit ToBSn
//a better smoothed outline would be nice 

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float aa_th = 1.01;
const float max_th = 0.99;
const float smoothMult = 1.0/(aa_th-max_th);

float calcMetaBalls(vec2 pos)
{
	float val =  0.35 / distance(pos, vec2(0.0, 0.0));
	val += 0.2 / distance(pos, mouse.xy*4.0-2.0);
	val += 0.1 / distance(pos*cos(time)+sin(-time), mouse.xy*4.0-2.0);
	return val;
}

void main(void)
{
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 4.0 - 2.0;
 	float val = 0.0;
  	float temp = calcMetaBalls(position);

 	if(temp > max_th)
	{
		if(temp<aa_th)
		{
			val = smoothstep(1.0, 0.0, (aa_th-temp)*smoothMult);
		}
		else
		{
			val = smoothstep(0.0, 0.3, (aa_th+temp)/smoothMult);
		}
    }
    gl_FragColor = vec4(val, val, val, 1.0);
}