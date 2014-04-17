#ifdef GL_ES
precision mediump float;
#endif
// mods by Casper from dist's source

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Singularity -- Using this for other applications. Makes a good flare image. Thanks to whoever made this originally!
// I made this - MrOMGWTF :)
// http://glsl.heroku.com/e#5250.0
#define BLADES 4.0
#define BIAS 0.15
#define SHARPNESS 5.5
#define COLOR 0.82, 0.65, 0.4
#define BG 0.34, 0.52, 0.76
#define ROTATION 3.14

float rand(vec2 co)
{
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 758.5453);
}

float distanceFromCircle (vec2 p, vec2 center)
{
	vec2 ratio = resolution.xy / resolution.x;
	return distance(p*ratio, center*ratio);
}

void main( void )
{
	
	const float fAmpModifier = 0.15;	// The height of the wave.
	const float fWaveSpeed = 2.0; 		// the speed at which it bounces up and down
	const float fSpeed = 0.01;		// the speed of the beam heading towards the center.
	const float k = 50.;  			// the number of iterations (waves within waves) i.e. 9 
	
	vec3 color = vec3(0.0, 0.0, 0.0); 	// background colour
	float vertColor = 0.0; 			// the intensity of this pixel
	
	
	
	vec2 pos = gl_FragCoord.xy / resolution.xy;
	vec2 uPos = pos;
	
	
	// Place the beam in the center.
	uPos.y -= 0.5;
	

	// Make the wave move from left to right.
	if (pos.x < 0.5)
	{
		uPos.x -= time * fSpeed;
	}
	
	// Make the wave move from right to left.
	else
	{
		uPos.x -= time * -fSpeed;
	}

	
	for( float i = 1.0; i < k; ++i )
	{
		float t = time * fWaveSpeed;
		
		uPos.y += sin( uPos.x * exp(i) - t) * fAmpModifier;
		
		float fTemp = abs(1.0 / (50.0 * k) / uPos.y);
		vertColor += fTemp;
		
		//color += vec3( fTemp * (i * 0.03), fTemp * i / k, pow(fTemp, 0.93) * 1.2 );
		color += vec3( fTemp * (i * 0.03), fTemp * i / k, pow(fTemp, 0.93) * 1.2 );
	}
	
	vec4 color_final = vec4(color, 1.0);
	gl_FragColor = color_final;
	float ft = fract(time);
	
	// Noisy colour.
	//gl_FragColor.rgb += vec3( rand( pos +  7.+ ft ),  rand( pos +  9.+ ft ), rand( pos + 11.+ ft ) ) / 32.0;
	
	
	// Remove the nasty harsh contrast between the two beams.
	vec2 vBarDist = abs(pos - vec2(0.5, 0.5));
	
	
	if (vBarDist.x < 0.02)
	{
		vec4 vCol = gl_FragColor / ((vBarDist.x / 0.02) + 0.02);
	
		float delta = vBarDist.y / 0.2;
		if (vBarDist.y < 0.2)	
		{
			gl_FragColor = mix( vCol, gl_FragColor, delta );
		}
	}
	
	
	/* THE CIRCLE */
	// If we are in the center, show the circle..
	float fDistance = distanceFromCircle(pos, vec2(0.5, 0.5));
	

	if (fDistance < 0.04)
	{
		float delta = fDistance / 0.04;
		gl_FragColor += vec4(1.-delta, 1.-delta, 0, 1.-delta);
	}
	
	if (fDistance < 0.1)
	{
		float delta = fDistance / 0.1;
		gl_FragColor += vec4(1.-delta, 1.-delta, 1.-delta, 1.-delta);
	}
	
	
	
	/*
	// extra yellow background b it
	pos = gl_FragCoord.xy / resolution.xy;
	uPos = pos;
	uPos.x -= 0.0;
	uPos.y -= 0.0;
	
	color = vec3(0.0);
	vertColor = 0.0;
	for( float i = 0.0; i < 4.0; ++i )
	{
		float t = time *(0.09);
	
		uPos.y += sin( uPos.y/1.0+uPos.x/1.0*(i/0.5+1.0)+t ) * 2.8; //3.1
		float fTemp = abs(1.0 / uPos.y/0.09 / 100.0);
		vertColor += fTemp;
		color += vec3( fTemp*i/4.0, fTemp*i/8.0, pow(fTemp,i/4.0)/16.0 );
	}
	
	color_final = vec4(color, 0.0);
	gl_FragColor += (color_final * 0.8);
	*/
	
	
	// Add the glowing balls? http://glsl.heroku.com/e#6105 or http://glsl.heroku.com/e#6238
	
	
	// Add the gowing sun rays
	/*
	vec2 sunpos = vec2(0.);
	vec2 position = (( gl_FragCoord.xy / resolution.xy ) - vec2(0.5)) / vec2(resolution.y/resolution.x,1.0);
	position = position * mat2(cos(ROTATION), -sin(ROTATION), sin(ROTATION), cos(ROTATION));
	vec2 t = position.yx - sunpos.yx;
	float alpha = 1.;
	
	float blade = clamp(pow(sin(atan(t.x, t.y)*BLADES)+BIAS, SHARPNESS), 0.0, 1.0);

	float dist = .1 / distance(sunpos, position) * 0.075;
	float dist2 = 2.0;
	dist2 = pow(dist2, 3.0);
	dist *= dist2;

	color = vec3(0.0);

	color += vec3(0.95, 0.65, 0.30) * dist;
	color += vec3(0.95, 0.45, 0.30) * min(1.0, blade *0.7) * dist*1.;

	color.rgb += rand( 0.1 * gl_FragCoord.xy ) / 255.0; //ooh look, no banding
	
	gl_FragColor += vec4( color.z,color.z,color.z, 1.0 );
	*/
	
	
	/** THE COOL RADIAL AND STUFF */
	const float pi_2_f = 3.1416*2.0;
	const float lineTickness = 0.0;
	const float lumaCount = 10.0;
	const float hueCount = 50.0;
	
	vec2 position =  gl_FragCoord.xy - (resolution.xy/2.0);
	
	float d = length(position);
	
	float v = mod(d + time/20.0*resolution.x + resolution.x/(lumaCount*2.0), resolution.x/lumaCount);
	v = abs(v - resolution.x/(lumaCount*2.0)) - lineTickness;
	
	float angle = acos(position.y/d) / pi_2_f;
	if(position.x>0.0) angle += (0.5-angle)*2.0;
	angle += time/60.0;
	
	float unit = d * pi_2_f;
	float a = mod(angle*unit + unit/(hueCount*2.0) , unit/hueCount);
	a = abs(a - unit/(hueCount*2.0)) - lineTickness;
	a = clamp(a, 0.0, 1.0);

	angle += .05;
	float u = 100.0;
	float r = mod(angle*u + u/(5.0*2.0) , u/3.0);
	r = abs(r - u/(5.0*2.0)) - 1.0;
	r = clamp(r, 0.0, 1.0);

	d /= length(resolution.xy);
	v = min(v, a)*d;

	float dr = .2+(sin(time*1.1)+1.0)/8.0;
	float dg = .2+(sin(time*1.2)+1.0)/8.0;
	float db = .2+(sin(time*1.4)+1.0)/8.0;
	gl_FragColor -= vec4(v/(r+dr),v/(r+dg),v/(r+db),1);
}
