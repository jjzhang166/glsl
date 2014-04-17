#ifdef GL_ES
precision mediump float;
#endif

// quadratic bezier curve evaluation
// posted by Trisomie21

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 GetUV(in vec2 A, in vec2 B, in vec2 C, in vec2 P)
{
	// Compute vectors        
	vec2 v0 = C - A ;
	vec2 v1 = B - A;
	vec2 v2 = P - A;
	
	// Compute dot products
	float dot00 = dot(v0, v0);
	float dot01 = dot(v0, v1);
	float dot02 = dot(v0, v2);
	float dot11 = dot(v1, v1);
	float dot12 = dot(v1, v2);
	
	// Compute barycentric coordinates
	float invDenom = 1.0 / (dot00 * dot11 - dot01 * dot01);
	float u = (dot11 * dot02 - dot01 * dot12) * invDenom;
	float v = (dot00 * dot12 - dot01 * dot02) * invDenom;

	return vec2(u + v*.5, u);
}

float DistanceQBSpline(in vec2 A, in vec2 B, in vec2 C, in vec2 P)
{
	vec2 uv = GetUV(A, B, C, P);
	
	// Clamp to start/end points
	//if((uv.x < 0.0) || (uv.y < 0.0) || (uv.x + uv.y >= 1.0)) return 1e20;
	
	// Compute gradient
	vec2 uvX = GetUV(A, B, C, P+vec2(1,0));
	vec2 uvY = GetUV(A, B, C, P+vec2(0,1));	
	vec2 ddx = uvX - uv;
	vec2 ddy = uvY - uv;
 	
 	float fx = (2.0*uv.x)*ddx.x-ddx.y;
  	float fy = (2.0*uv.x)*ddy.x-ddy.y;
	
  	// Distance to quadratic curve
 	float d = (uv.x*uv.x - uv.y)/sqrt(fx*fx + fy*fy); 
	return abs(d);
}

void main(void)
{
	vec2 position = gl_FragCoord.xy;
	vec2 p[3];
	float s = 1.0;//resolution.x/1920.0;
	
	p[0] = vec2(resolution.x*.30,resolution.y*.4);
	p[1] = mouse*resolution;
	p[2] = vec2(resolution.x*.60,resolution.y*.6);

	// make the bez pass thru the control point (THX)
	p[1]+=(p[1]-((p[0]+p[2])*0.5));
	
	float d = DistanceQBSpline(p[0], p[1], p[2], position);	
	
	//d -= 8.0;	// Thickness
	//d = abs(d);	// Outline
	//d *= 1.0/2.0;	// softness
	
	// Curve Control point
	float r = 4.0*s;
	d = min(d, length(mouse*resolution - position) - r);
	d = min(d, length(p[0] - position) - r);
	d = min(d, length(p[2] - position) - r);
	
	d = clamp(d, 0.0, 1.0);
	d = mix(0.8, 0.5, d);
	gl_FragColor = vec4(d,d,d, 1.0);

}