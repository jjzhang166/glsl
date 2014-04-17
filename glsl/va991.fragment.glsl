#ifdef GL_ES
precision mediump float;
#endif

//
// Simple Flame Particles Example
// By Matt White
//

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform sampler2D backBuffer;

bool AtMouse(vec2 pos)
{
	float radius = 0.008;
	float pulseSpeed = 4.0;
	float orbit		 = 0.05 * ((sin(time * pulseSpeed) + 1.5) * 0.5);
	float orbitTwo	 = 0.05 * ((sin(-time * pulseSpeed) + 1.5) * 0.5);
	
	float orbitSpeed	= 3.0;
	float newTime	= time * orbitSpeed;
	float k13PI = 3.14157 * 0.33;
	float k23PI = 3.14157 * 0.66;
	float k33PI = 3.14157 * 0.99;
	float k43PI = 3.14157 * 1.22;
	float k53PI = 3.14157 * 1.55;
	
	vec2 toOrbitOne 	= pos - (mouse + vec2(sin(newTime) * orbit, cos(newTime) * orbit));
	vec2 toOrbitTwo 	= pos - (mouse + vec2(sin(newTime + k13PI) * orbitTwo, cos(newTime + k13PI) * orbitTwo));
	vec2 toOrbitThree   = pos - (mouse + vec2(sin(newTime + k23PI) * orbit, cos(newTime + k23PI) * orbit));
	vec2 toOrbitFour   = pos - (mouse + vec2(sin(newTime + k33PI) * orbitTwo, cos(newTime + k33PI) * orbitTwo));
	vec2 toOrbitFive   = pos - (mouse + vec2(sin(newTime + k43PI) * orbit, cos(newTime + k43PI) * orbit));
	vec2 toOrbitSix   = pos - (mouse + vec2(sin(newTime + k53PI) * orbitTwo, cos(newTime + k53PI) * orbitTwo));
	
	return length(toOrbitOne) < radius || length(toOrbitTwo) < radius || length(toOrbitThree) < radius ||
			length(toOrbitFour) < radius || length(toOrbitFive) < radius || length(toOrbitSix) < radius;
}

void main( void ) 
{
	vec4 flameMax = vec4(1.0, 0.0, 0.0, 1.0);
	vec4 flameMin = vec4(1.0, 1.0, 0.0, 1.0);
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 pixel = 1.0/resolution;
	
	vec4 oldPixel	= texture2D(backBuffer, position);
	vec4 newPixel	= oldPixel;
	
	if(AtMouse(position))
	{
		newPixel	= flameMin;
	}
	else
	{
		vec4  l = texture2D(backBuffer, position - vec2(0.0, pixel.x));
		vec4  r = texture2D(backBuffer, position + vec2(0.0, pixel.x));
		vec4  u = texture2D(backBuffer, position - vec2(0.0, pixel.y));
		newPixel = (l+r+u)*0.33;
		
		if(newPixel.a > 0.5)
			newPixel.xyz = mix(flameMax, flameMin, (newPixel.a - 0.5) * 2.0).xyz;
						
	}

	gl_FragColor = newPixel;
}

