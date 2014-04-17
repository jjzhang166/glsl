#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec4 bgW = vec4(.6,.6,.9,1.);
vec4 bgE = vec4(.3,.2,.9,1.);

vec4 sunS = vec4(1.,.6,.2,1.);
vec4 sunN = vec4(1.,.2,.2,1.);

vec4 ground1 = vec4(1.,.8,.4,1.);
vec4 ground2 = vec4(1.,.6,.2,1.);


vec4 addCircle(vec4 color, vec4 backColor, vec2 center, float size, float smoothness)
{
	vec2 fragPos = ( gl_FragCoord.xy / resolution.xy );
	vec2 vDist = center - fragPos;
	vDist.y /= (resolution.x/resolution.y);
	float d = length(vDist);

	if( d > size/2. )
		return backColor;
	
	d /= size/2.;
	d = 1. - d;
	d = pow(d,1./smoothness);
	
	vec4 outColor = mix(color,backColor,1.-d);
	
	return outColor;	
}

float addNoise(vec2 P)
{
  vec2 Pi = ONE*floor(P)+ONEHALF; // Integer part, scaled and offset for texture lookup
  vec2 Pf = fract(P);             // Fractional part for interpolation

  // Noise contribution from lower left corner
  vec2 grad00 = texture2D(permTexture, Pi).rg * 4.0 - 1.0;
  float n00 = dot(grad00, Pf);

  // Noise contribution from lower right corner
  vec2 grad10 = texture2D(permTexture, Pi + vec2(ONE, 0.0)).rg * 4.0 - 1.0;
  float n10 = dot(grad10, Pf - vec2(1.0, 0.0));

  // Noise contribution from upper left corner
  vec2 grad01 = texture2D(permTexture, Pi + vec2(0.0, ONE)).rg * 4.0 - 1.0;
  float n01 = dot(grad01, Pf - vec2(0.0, 1.0));

  // Noise contribution from upper right corner
  vec2 grad11 = texture2D(permTexture, Pi + vec2(ONE, ONE)).rg * 4.0 - 1.0;
  float n11 = dot(grad11, Pf - vec2(1.0, 1.0));

  // Blend contributions along x
  vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade(Pf.x));

  // Blend contributions along y
  float n_xy = mix(n_x.x, n_x.y, fade(Pf.y));

  // We're done, return the final noise value.
  return n_xy;
}

////////////////////////////

void main( void ) 
{
	float WE = mouse.x;
	float SN = mouse.y;

	vec4 background = mix(bgW,bgE,WE);
	vec4 sun = mix(sunS,sunN,SN);
	vec4 ground = mix(ground1,ground2, SN);
	
	vec4 o = background;
	o = addCircle(sun, o, mouse, .1, 2.);
	o += addNoise(mouse);
	o = addCircle(ground, o, vec2(.5,-1.6), 2.5, 15.);
	
	
	gl_FragColor = addNoise(mouse);


}	