// fizzer

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define EPS vec2(1e-3, 0.0)
#define ON vec2(1.0, 0.0)


vec2 rotate(float a, vec2 p)
{
   return vec2(cos(a) * p.x + sin(a) * p.y, cos(a) * p.y - sin(a) * p.x);
}

vec3 rotateX(float a, vec3 v)
{
   return vec3(v.x, cos(a) * v.y + sin(a) * v.z, cos(a) * v.z - sin(a) * v.y);
}

vec3 rotateY(float a, vec3 v)
{
   return vec3(cos(a) * v.x + sin(a) * v.z, v.y, cos(a) * v.z - sin(a) * v.x);
}

float cube(vec3 p, vec3 o, vec3 s)
{
   return length( max(vec3(0.0), abs(p - o) - s) );
}

float titanDist(vec3 p)
{
   float rpc = 10.0;
   float c = 3.0;
   float cc = floor(time / c), cf = fract(time / c);

   
   float it = floor(time);
   float ft = fract(time);


   float d = 1e10;

   d = min(d, cube(p, vec3(0.0, 0.0, 0.0), vec3(0.1, 0.2, 0.1)));     // T
   d = min(d, cube(p, vec3(0.0, 0.15, 0.0), vec3(0.2, 0.05, 0.1)));   // T
   d = min(d, cube(p, vec3(0.3, -0.08, 0.0), vec3(0.05, 0.12, 0.1))); // I
   d = min(d, cube(p, vec3(0.3, 0.15, 0.0), vec3(0.05, 0.05, 0.1)));  // I
   d = min(d, cube(p, vec3(0.6, 0.0, 0.0), vec3(0.1, 0.2, 0.1)));     // T
   d = min(d, cube(p, vec3(0.6, 0.15, 0.0), vec3(0.2, 0.05, 0.1)));   // T
   d = min(d, cube(p, vec3(1.05, 0.15, 0.0), vec3(0.2, 0.05, 0.1)));  // A
   d = min(d, cube(p, vec3(0.9, 0.0, 0.0), vec3(0.05, 0.2, 0.1)));    // A
   d = min(d, cube(p, vec3(1.2, 0.0, 0.0), vec3(0.05, 0.2, 0.1)));    // A
   d = min(d, cube(p, vec3(1.05, 0.0, 0.0), vec3(0.2, 0.02, 0.1)));   // A
   d = min(d, cube(p, vec3(1.5, 0.15, 0.0), vec3(0.2, 0.05, 0.1)));   // N
   d = min(d, cube(p, vec3(1.35, 0.0, 0.0), vec3(0.05, 0.2, 0.1)));   // N
   d = min(d, cube(p, vec3(1.65, 0.0, 0.0), vec3(0.05, 0.2, 0.1)));   // N

   return d;
}

float titanMask(vec2 t, float s)
{
   return smoothstep(0.001 / s, 0.0, titanDist(vec3((t + vec2(0.75, 0.0)) / s, 0.0)));
}

float square(vec2 p, vec2 s)
{
   return length( max(vec2(0.0), abs(p) - s ) );
}

const int n = 6;

float greybars(vec2 p, float t)
{
   float d = 1e10;
   for(int i = 0; i < n; i += 1)
   {
      float i2 = float(i) / float(n);
      float ofs = abs(cos(i2 * 70.0));
      vec2 o = vec2(pow(2.0 * (-1.0 + t * 2.0) - ofs, 3.0), (-0.8 + 2.0 * i2) * 0.6);
      d = min(d, square(p - o, vec2(0.8, 0.07)));
   }
   return smoothstep(0.01, 0.0, d) * 0.5;
}

float shade(vec2 p)
{
	p.x += time * mix(0.2, -0.2, step(p.y, 0.0));
	p.y = floor(p.y * 30.0 + cos(p.x * 30.0) * 0.1) / 30.0;
	return (smoothstep(-1.0, -0.7, p.y) - smoothstep(0.7, 1.0, p.y)) * 0.5 + 0.5;
}

float floatingSquare(vec2 p)
{
	float d = square(p, vec2(0.24));
	return smoothstep(0.01, 0.0, d);
}

void main()
{
   vec2 t = (gl_FragCoord.xy / resolution.xy - vec2(0.5)) * 2.0 * vec2(resolution.x / resolution.y, 1.0);

   t = floor(t * 60.0) / 60.0;
	
   float tt= time * 0.2;
   float zoom = fract(tt);
   float inversion = mod(floor(tt), 2.0);

   float m = titanMask(rotate(fract(floor(tt) * 0.84372) * 0.4, t), 1e-3 + pow(zoom, 6.0) * 20.0);

   float f = mix(m, 1.0 - m, inversion);

   f = mix(f, mix(inversion, 0.3, greybars(rotate(floor(tt) * 0.7, t), zoom)) , 1.0 - m);

	for(int i = 0; i < 6; i += 1)
	{
		float a = float(i) + time * 0.02;
		//f += floatingSquare(rotate(float(i), t + vec2(-0.4 + cos(a * 10.0) * 0.2, -1.0 + 2.0 * fract( float(i) / 6.0 - time * 0.2)  ))) * 0.2;
	}

   gl_FragColor.rgb = pow(0.8 * mix(vec3(0.15, 0.3, 0.1), vec3(0.2, 0.7, 0.4), f) * shade(t), vec3(0.55));
   gl_FragColor.a = 1.0;
}