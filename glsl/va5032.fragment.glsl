/* wzl was here, bringing you the finest of fibonacci 
 *
 * making your eyes cum since 2008 
 * http://wzl.vg  
 * http://trbl.at 
 */  

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D buffer;

const int maxseed = 512;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy ) - vec2(0.5,0.5);
	p *= 2.0;
	float ar = resolution.x/resolution.y;
	p.x *= ar;
	vec3 col = vec3(p,p.x);
	
	
	
	col = mix(col, texture2D(buffer,  gl_FragCoord.xy / resolution.xy ).rgb, 0.91);
	float t = mod(time*16., float(maxseed*2));

	for(int i = 0; i < maxseed; i++)
	{
		if(float(i) > t)
			break;
		
		float distance = 0.002;
		
		float tau = 6.283;
		float a = atan(p.x, p.y) + mod(2.3986 * float(i), 6.283);
		a = mod(2.3986 * float(i) - time*0.6, 6.283);
		float d = length(p);
		float tt = t - float(i);
		
			vec2 c = (p+(vec2(sin(a), cos(a) )*tt*-distance))  ;//* tt / float(maxseed);
		
		
			float f = length(c);
			
			if(f < 0.02 * pow(d+.6,3.))
			{
				vec3 c = vec3(1.0, .3, 0.)*0.3;
				
				if(mod(float(i), 4.0) == 0.0)
					c = vec3(0.1, 0.8, 0.3);
				if(mod(float(i), 7.0) == 0.0)
					c = vec3(0.7, 0.8, 0.2);
				
				col = mix(col, c, 1.0);
			}		
	}
	
	
	gl_FragColor = vec4(col,1.0);

}