//
// Sidescroller WTF, by @rianflo
//
// @danbri added running man from http://glsl.heroku.com/e#10532.6 
// which in turn took it from David Hoskins shadertoy, https://www.shadertoy.com/view/MdsGRS

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D bb;

vec3 mod289(vec3 x);
vec2 mod289(vec2 x);
vec3 permute(vec3 x);
float snoise(vec2 v);



float timeT;
float backTime;
float forTime;
float runnerHeight;
float runCycle;
float speed;

//----------------------------------------------------------------------------
float Box(vec2 p, vec2 b)
{
	return length(max(abs(p)-b,0.0));
}

//----------------------------------------------------------------------------
vec2 Segment( vec2 a, vec2 b, vec2 p )
{
	vec2 pa = p - a;
	vec2 ba = b - a;
	float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
	return vec2( length( pa - ba*h ), h );
}

//----------------------------------------------------------------------------
float Head( vec2 p, float s )
{
	p.y *= .75;
	return length(p)-s;
}

//----------------------------------------------------------------------------
vec2 Rotate(vec2 pos, vec2 piv, float ang)
{
	mat2 m = mat2(cos(ang), sin(ang), -sin(ang), cos(ang));
	pos = (m * (pos-piv))+piv;
	return pos;
}

//----------------------------------------------------------------------------
float Smin( float a, float b )
{
    float k = 0.025;
	float h = clamp( 0.5 + 0.5*(b-a)/k, 0.0, 1.0 );
	return mix( b, a, h ) - k*h*(1.0-h);
}
	
//----------------------------------------------------------------------------
vec2 Running( vec2 p)
{
	// Oh the horror! - of magic numbers. ;)
	float material = 0.0;
	float d;
	float ang = -.2;
	mat2 leanM = mat2(cos(ang), sin(ang), -sin(ang), cos(ang));

	// scale here didn't do quite what i planned, but it made the walk more _something_ (silly?) @danbri
	runnerHeight = (sin(runCycle-.27)*.15);
	runnerHeight= pow(runnerHeight,1.3)*.8-.92+ang*.18;

	p += vec2(-speed*.4, runnerHeight);
	p *= leanM;
	float headX = sin(runCycle*.25)*.025;
	d = Head(p-vec2(.44+headX, -0.02-headX*.5), .06);
	
	float arm1 = sin(runCycle)*.6*(speed*.2+1.0);
	float leg1 = sin(runCycle)*.7*(speed*.05+.5);
	
	// Neck...
	vec2 h = Segment( vec2(0.4,-0.1-0.01-headX*.5), vec2(0.42+headX,-.04), p );
	float d2 = h.x - 0.03 + h.y*0.005;
	d = Smin(d, d2 );
	// Body...
	h = Segment( vec2(0.4,-0.17), vec2(0.4,-.37), p );
	d2 = h.x - 0.065 + h.y*0.03;
	d = Smin(d, d2 );
	
	// Upper arm...
	vec2 elbow = Rotate(vec2(0.4,-.3), vec2(.4,-0.14), arm1);
	h = Segment(vec2(0.4,-0.14),  elbow, p );
	d2 = h.x - 0.04 + h.y*0.01;
	d = min(d, d2 );
	// Lower arm...
	vec2 wrist = Rotate(elbow+vec2(.13, -.02), elbow, arm1*1.5-.3);
	h = Segment(elbow,  wrist, p );
	d2 = h.x - 0.03 + h.y*0.01;
	d = min(d, d2 );
	// Hand...
	vec2 hand = Rotate(wrist+vec2(.005, -0.0), wrist, arm1*1.5-.3);
	h = Segment(wrist,  hand, p );
	d2 = h.x - 0.03 + h.y*0.001;
	d = min(d, d2 );
	
	// Upper leg...
	vec2 knee = Rotate(vec2(0.4,-.55), vec2(.4,-0.35), -leg1+.5);
	h = Segment(vec2(0.4,-.35), knee, p );
	d2 = h.x - 0.05 + h.y*0.015;
	d = Smin(d, d2 );
	
	// Lower leg...
	vec2 rotFoot = Rotate(knee+vec2(.0, -.22), knee, -(-leg1*.3+1.6));
	rotFoot = Rotate(rotFoot, knee, smoothstep(-.2, .2, -(leg1)*.15)*5.2-1.2);
	h = Segment(knee, rotFoot , p );
	d2 = h.x - 0.03+ h.y*0.008;
	d = Smin(d, d2 );
	
	// Foot...
	vec2 toes = Rotate(rotFoot+vec2(.09, 0.0), rotFoot, smoothstep(-.1, .15, -leg1*.2)*2.4-1.7-leg1);
	h = Segment(rotFoot, toes, p );
	d2 = h.x - 0.018 + h.y*0.005;
	d = Smin(d, d2 );
	
	if (d > 0.005)
	{
		// Do shadowed back limbs if others haven't been hit...
		// Upper arm 2...
		elbow = Rotate(vec2(0.4,-.3), vec2(.4,-0.14), -arm1);
		h = Segment(vec2(0.4,-0.14), elbow, p );
		d2 = h.x - 0.04 + h.y*0.01;
		d = min(d, d2 );
		// Lower arm 2...
		wrist = Rotate(elbow+vec2(.13, -.01), elbow, -arm1*1.5+.1);
		h = Segment(elbow,  wrist, p );
		d2 = h.x - 0.03 + h.y*0.01;
		d = min(d, d2 );
		// Hand...
		vec2 hand = Rotate(wrist+vec2(.005, -0.0), wrist, -arm1*1.5-.3);
		h = Segment(wrist,  hand, p );
		d2 = h.x - 0.03 + h.y*0.001;
		d = min(d, d2 );
		// Upper leg...
		knee = Rotate(vec2(0.4,-.55), vec2(.4,-0.35), leg1+.5);
		h = Segment(vec2(0.4,-.35), knee, p );
		d2 = h.x - 0.05 + h.y*0.02;
		d = min(d, d2 );
		// Lower leg...
		rotFoot = Rotate(knee+vec2(.0, -.22), knee, -(leg1*.3+1.6));
		rotFoot = Rotate(rotFoot, knee, smoothstep(-.2, .2, leg1*.15)*5.2-1.2);
		h = Segment(knee, rotFoot, p );
		d2 = h.x - 0.03+ h.y*0.008;
		d = Smin(d, d2 );
	
		// Foot...
		toes = Rotate(rotFoot+vec2(.09, 0.0), rotFoot, smoothstep(-.1, .15, leg1*.2)*2.4-1.7+leg1);
		h = Segment(rotFoot, toes, p );
		d2 = h.x - 0.018 + h.y*0.005;
		d = Smin(d, d2 );
		material = 2.0;
	}

	return vec2(d, material);
}

//----------------------------------------------------------------------------

// ------------------------------------------------------------------------


float line(vec2 p, float k, float d)
{
	return p.y - k*p.x+d;
}
            
float circle(vec2 p, vec2 t, float r)
{
	return length(p-t) - r;
}

float shape(vec2 p, float iso)
{
	float sd = line(p, 0.0, 0.0);
    	sd += snoise(p*4.0) * 0.025 + snoise(p*2.0) * 0.05 + snoise(p*1.0) * 0.1 + snoise(p*0.5) * 0.2;
	return sd - iso;
}





void main() 
{
	vec2 p = (-resolution.xy + 2.0 * gl_FragCoord.xy) / resolution.y;
	vec2 m = (mouse * 2.0 - 1.0) * vec2(resolution.x / resolution.y, 1.0);
		
	vec2 p0 = p + vec2(time * 0.05, 0.0);
	vec2 p1 = p + vec2(time * 0.5, 0.0);
	vec2 p2 = p + vec2(time * 1.0, 0.0);

	float sd0 = shape(p0, 0.0);
	float sd1 = shape(p1, 0.0);
	float sd2 = shape(p2, 0.0);

	// ok we're going to do something non-GPU friendly next
	vec4 state = texture2D(bb, vec2(0.0)) * 4.0 - 2.0;
	vec2 bpos = state.xy;
	vec2 bvel = state.zw;
	
	vec2 md = normalize(m - bpos);
	bvel = bvel + md * 0.25;
	vec2 bposn = bpos + 1.0/60.0 * bvel;
	
	// primitive collision with the middle shape
	vec2 bposw = bpos + vec2(time * 0.5, 0.0);
	float d1 = shape(bposw, -0.2);
	vec2 grad1 = vec2(shape(bposw + vec2(0.0001, 0.0), -0.2), shape(bposw - vec2(0.0, 0.0001), -0.2));
	grad1 = (vec2(d1) - grad1) / 0.0001;
	if (d1 < 0.0) 
	{	
		bposn = bpos - grad1 * d1;	
	}

	
	vec3 c = vec3(1.0) - vec3((sd0 + sd1 + sd2)*0.333) * vec3(1.0, 1.0, 0.5);
	float g = snoise(vec2(p2.x + snoise(p2*32.0)*0.015, p2.x) * 32.0)*0.02;
	float s = circle(p, vec2(0.9, 0.2), 0.5);
	float ball = circle(p, bpos, 0.05);
	
	if (sd2 + g < -0.75)
	{
		c = vec3(0.0, 0.4, 0.3); 
		c += sd2 * 0.01;
	}
	else if (sd1 < -0.2) 
	{
		c = vec3(0.0, 0.3, 0.2);
		c -= sd1 * 0.25;
	} 
	else if (sd0 < -0.0)
	{
		c = vec3(0.95, 0.95, 1.0);
		c += sd0 * 0.5;
	} 
	else if (s < 0.0)
	{
		c = c + vec3(smoothstep(0.0, 1.0, -s/0.5));
	}
	
	
	timeT = time*0.1;
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	uv.x *= resolution.x/resolution.y;
	vec3 col;
	speed = 4.0;
	runCycle = timeT*7.0*speed;
	

	float background = 0.0005;
	col = vec3(background);
	
	
	vec2 res = Running(uv);

	if (res.x < 0.005)
	{
		col = mix(col, vec3(1.0), smoothstep(0.0, .0005, res.x) );
	}
	
	col = sqrt(col);
	//c = sqrt(c);
	c += col;
	
	
	
	if (length(gl_FragCoord.xy) <= 1.0) 
	{
		// save state
		gl_FragColor = (vec4(bposn, bvel) + 2.0) / 4.0;
	}
	else
	{
		gl_FragColor = vec4(c + snoise(p2*256.0)*0.02, 1.0);
	}
}


// lib ---------------------------------------------------------------

//
// Description : Array and textureless GLSL 2D simplex noise function.
//      Author : Ian McEwan, Ashima Arts.
//  Maintainer : ijm
//     Lastmod : 20110822 (ijm)
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise
// 

vec3 mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 mod289(vec2 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 permute(vec3 x) {
  return mod289(((x*34.0)+1.0)*x);
}

float snoise(vec2 v)
  {
  const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                      0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                     -0.577350269189626,  // -1.0 + 2.0 * C.x
                      0.024390243902439); // 1.0 / 41.0
// First corner
  vec2 i  = floor(v + dot(v, C.yy) );
  vec2 x0 = v -   i + dot(i, C.xx);

// Other corners
  vec2 i1;
  //i1.x = step( x0.y, x0.x ); // x0.x > x0.y ? 1.0 : 0.0
  //i1.y = 1.0 - i1.x;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  // x0 = x0 - 0.0 + 0.0 * C.xx ;
  // x1 = x0 - i1 + 1.0 * C.xx ;
  // x2 = x0 - 1.0 + 2.0 * C.xx ;
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;

// Permutations
  i = mod289(i); // Avoid truncation effects in permutation
  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
		+ i.x + vec3(0.0, i1.x, 1.0 ));

  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
  m = m*m ;
  m = m*m ;

// Gradients: 41 points uniformly over a line, mapped onto a diamond.
// The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)

  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;

// Normalise gradients implicitly by scaling m
// Approximation of: m *= inversesqrt( a0*a0 + h*h );
  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

// Compute final noise value at P
  vec3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}
