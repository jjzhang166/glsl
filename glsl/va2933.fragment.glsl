// @mod* rotwang , gradients

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;


vec3 image(vec2 p)
{
	float ts = sin(time)*0.5+0.5;
	float tc = cos(time)*0.5+0.5;
	float c = 1. - length(p)*ts;
	vec3 color = vec3( 0.0, tc, ts );
	color.x = c * ts;
	color = clamp(color, 0.13, 1.0);
	return color * vec3(p, 0.5);
}


vec2 checka(in vec2 p){
	float a,x,z,t=0.0;
	
	for (int xii=-8;xii<7;xii++) {
		for (int zii=-8;zii<7;zii++) {
			x=fract((p.x+float(xii)*0.06)*0.5);
			z=fract((p.y+float(zii)*0.06)*0.5);
			if (x>.5)
				if (z>.5) {
					a=0.0;
				} else {
					a=1.0;
				} 
			else
				if (z>.5) {
					a=1.0;
				} else {
					a=0.0;
				}	
		
			t+=a * (20.0-float(xii));

		}
	}
	return vec2(t*.008);
} 


vec2 distort(vec2 p)
{
	float tt = time * 0.1;
	float ts = sin(tt);
	float tc = cos(tt);

	vec2 uv;

	uv.x = tc  * p.x;
	uv.y = ts * p.y;
	
	uv += vec2(ts ) + vec2(tc);
	
	return uv * checka(uv);
}

vec3 effect()
{

 	
	vec2 pos = gl_FragCoord.xy / resolution;
	

	return image(distort(pos));
}


void main()
{
	gl_FragColor = vec4(effect(), 1.);
}