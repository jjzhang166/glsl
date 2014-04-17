#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
float s = 1.;

mat4 m1 = mat4(
vec4(-s,-s,-s,-s),
vec4(s,-s,-s,-s),
vec4(s,-s,s,-s),
vec4(-s,-s,s,-s));
	
mat4 m2 = mat4(
vec4(-s,s,-s,-s),
vec4(s,s,-s,-s),
vec4(s,s,s,-s),
vec4(-s,s,s,-s));	
	
mat4 m3 = mat4(
vec4(-s,-s,-s,s),
vec4(s,-s,-s,s),
vec4(s,-s,s,s),
vec4(-s,-s,s,s));

	
mat4 m4 = mat4(
vec4(-s,s,-s,s),
vec4(s,s,-s,s), 
vec4(s,s,s,s),
vec4(-s,s,s,s)); 

vec4 a( vec4 p, int a)
{	
	float angle = time/4.;
		float x = p.x, y = p.y, z = p.z, t = p.w;
			if (a == 1) {
			p.x = cos(angle)*x - sin(angle)*y; 
			p.y = sin(angle)*x + cos(angle)*y;
			}		
			if (a == 2) {
			p.x = cos(angle)*x + sin(angle)*z; 
			p.z = -sin(angle)*x + cos(angle)*z;
			}	
			if (a == 3) {				
			p.x = cos(angle)*x + sin(angle)*t; 
			p.t = -sin(angle)*x + cos(angle)*t;
			}		
			if (a == 4) {			
			p.y = cos(angle)*y + sin(angle)*t; 
			p.w = -sin(angle)*y + cos(angle)*t;
			}	
			if (a == 5) {
			p.z = cos(angle)*z - sin(angle)*t; 
			p.w = sin(angle)*z + cos(angle)*t;
			}
			if (a == 6) {		
			p.y = cos(angle)*y - sin(angle)*z; 
			p.z = sin(angle)*y + cos(angle)*z;
			}	                
			return p;
}
void line(vec4 a, vec4 b)
{	
	vec2 aa = vec2((a.x*100.) / (a.w+2.5)+ 400., (a.y*100.) / (a.w+2.5) + 150.); 
	vec2 bb = vec2((b.x*100.) / (b.w+2.5)+ 400., (b.y*100.) / (b.w+2.5) + 150.); 
	float c = abs(distance(gl_FragCoord.xy, aa) + distance(gl_FragCoord.xy, bb) - distance(bb, aa));
	if (c < .1)
	{
		gl_FragColor.z = s;
		gl_FragColor.y = a.w;
		gl_FragColor.x = b.w;
	}	
	
}
void main( void )
{
	for (int i = 0; i < 4; i++)
      {
	      
	      m1[i] = a(m1[i], 1); m2[i] = a(m2[i], 1); m3[i] = a(m3[i], 1); m4[i] = a(m4[i], 1); 
	      /*m1[i] = a(m1[i], 2); m2[i] = a(m2[i], 2); m3[i] = a(m3[i], 2); m4[i] = a(m4[i], 2); 
	      m1[i] = a(m1[i], 3); m2[i] = a(m2[i], 3); m3[i] = a(m3[i], 3); m4[i] = a(m4[i], 3); 
	      m1[i] = a(m1[i], 4); m2[i] = a(m2[i], 4); m3[i] = a(m3[i], 4); m4[i] = a(m4[i], 4); */
	      m1[i] = a(m1[i], 5); m2[i] = a(m2[i], 5); m3[i] = a(m3[i], 5); m4[i] = a(m4[i], 5); 
	      m1[i] = a(m1[i], 6); m2[i] = a(m2[i], 6); m3[i] = a(m3[i], 6); m4[i] = a(m4[i], 6); 
      }
     
        line(m1[0], m1[1]);  
	line(m1[1], m1[2]);
	line(m1[2], m1[3]);
	line(m1[3], m1[0]);
	
	line(m2[0], m2[1]);
	line(m2[1], m2[2]);
	line(m2[2], m2[3]);
	line(m2[3], m2[0]);
	
	line(m3[0], m3[1]);
	line(m3[1], m3[2]);	
	line(m3[2], m3[3]);
	line(m3[3], m3[0]);
	
	line(m1[0], m2[0]);
	line(m1[3], m2[3]);
	line(m1[2], m2[2]);
	line(m1[1], m2[1]);
	
	line(m4[0], m4[1]);
	line(m4[1], m4[2]);
	line(m4[2], m4[3]);
	line(m4[3], m4[0]);
	
	line(m3[0], m4[0]);
	line(m3[1], m4[1]);
	line(m3[2], m4[2]);
	line(m3[3], m4[3]);
	line(m1[0], m3[0]);	
	line(m1[2], m3[2]);
	line(m1[1], m3[1]);
	line(m1[3], m3[3]);
	line(m2[0], m4[0]);
	line(m2[3], m4[3]);
	line(m2[2], m4[2]);
	line(m2[1], m4[1]);	
}
