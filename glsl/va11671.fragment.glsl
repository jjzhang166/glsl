#ifdef GL_ES
precision mediump float;
#endif
#define size 10.
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D  backbuffer;
vec3 color;
vec4 shadow = texture2D(backbuffer, gl_FragCoord.xy/resolution);
void circle2(float i, vec2 m)
{	
	vec2 a = vec2(floor(i / size), mod(i, size)) * resolution.y / size + vec2(50.,20.);
	float s  = distance(gl_FragCoord.xy, a);
	if (s < 50./size)
	{
           if (distance(vec2(shadow.b, shadow.b), shadow.rg) > 0.) color.rg += vec2(1./s,1./s);
	   if (shadow.r == shadow.b) color.b += 1./s; 
	   gl_FragColor.a = 1.;
	}
}     
void change(float i)
{			
			float t = mod(i, size);
			for (int k = 0; k < int(size); k++)      
			{
			    vec2 tt = vec2(floor(t / size), mod(t, size)) * resolution.y / size + vec2(50.,20.);
			    if (abs(t - i)> .01) circle2(t, tt); 
			    t += size;		           
			}
			t = size * floor(i / size);             
			for (int k = 0; k < int(size); k++)
			{
			    vec2 tt = vec2(floor(t / size), mod(t, size)) * resolution.y / size + vec2(50.,20.);
			     if (abs(t - i)> .01) circle2(t, tt);
				t++;				
			}
}
void circle(float i, vec2 m)
{		
	vec2 a = vec2(floor(i / size), mod(i, size)) * resolution.y / size + vec2(50.,20.);
	float s  = distance(gl_FragCoord.xy, a);
	if (s < 50./size)
	{
             if (shadow.rgb == vec3(0,0,0)) color.b += 1./s;
             if (distance(m, a) >= 50./size) gl_FragColor.a = 0.;
	     if (gl_FragColor.a == 0. && distance(m, a) < 50./size) change(i);		
	}
}
	
void main( void ) {	
	float k = 0.;	
	for (int i = 0; i < int(size) * int(size); i++)	 
		circle(k++, mouse.xy * resolution);	
	gl_FragColor.rgb = .3 * color;	
}
