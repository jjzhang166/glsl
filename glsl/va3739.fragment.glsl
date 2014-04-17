#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 permute(vec3 x) { return mod(((x*34.0)+1.0)*x, 289.0); }

// Perlin simplex noise
float snoise(vec2 v)
  {
  const vec4 C = vec4(0.211324865405187, 0.366025403784439,
					 -0.577350269189626, 0.024390243902439);
  vec2 i  = floor(v + dot(v, C.yy) );
  vec2 x0 = v -   i + dot(i, C.xx);
  vec2 i1;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
//  i1.x = step( x0.y, x0.x ); // x0.x > x0.y ? 1.0 : 0.0
//  i1.y = 1.0 - i1.x;
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;
  i = mod(i, 289.0);
  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
	+ i.x + vec3(0.0, i1.x, 1.0 ));
  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy),
    dot(x12.zw,x12.zw)), 0.0);
  m = m*m ;
  m = m*m ;
  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;
  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );
  vec3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}

float fbm( vec2 p)
{
	float f=0.0;
	
	f += 0.5000*snoise(p); p*=2.02;
	f += 0.2500*snoise(p); p*=2.03;
	f += 0.1250*snoise(p); p*=2.01;
	f += 0.0625*snoise(p); p*=2.04;
	f /= 0.9375;
	return f;
}

void main( void ) {

	float f;
	
	vec2 p = (gl_FragCoord.xy / resolution.xy)*2.0-1.0;
	p.x *= resolution.x/resolution.y;
	
	float background = smoothstep(-.25, 0.0, p.x);
	p.x-=0.8;
		
	float a = atan(p.y, p.x);
	float r = sqrt(dot(p,p)); 
	
	vec3 col = vec3(1);

	if (r<0.8) {
		// initial blue
		col = vec3(0.0, 0.3, 0.4);
		
		// mix with noisy green
		f = fbm(p*2.0);
		col = mix(col, vec3(.2,.5,.4), f);
		
		// yellow around pupil
		f = 1.0-smoothstep(0.2, 0.5, r);
		col = mix(col, vec3(.9,.6,.2), f);
		
		// White strands
		f = smoothstep(-0.1, 1.0, fbm(vec2(r*3.0,a*6.0)));
		col = mix(col, vec3(1), f);

		// Dark splotches
		f = smoothstep( 0.1, 0.9, fbm(vec2(r*5.0,a*7.0)));
		col *= (1.0-f*.5);
		
		// darken edges for sphere shape
		f = smoothstep(0.6, 0.8, r);
		col *= 1.0-.5*f;
		
		// pupil
		f = smoothstep(0.2, 0.25, r);
		col *=f;
		
		// fade edge to white
		f = smoothstep(0.77, 0.8, r);
		col = mix(col, vec3(1), f);
	}
	
	gl_FragColor = vec4( col * background, 1.0 );

}