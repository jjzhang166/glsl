//by @c5h12

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

vec3 rotX(vec3 p,float a){
	float s=sin(radians(a)), c=cos(radians(a)); 
	return vec3(p.x,p.y*c-s*p.z,p.y*s+c*p.z);
}

vec3 rotY(vec3 p,float a){
	float s=sin(radians(a)), c=cos(radians(a)); 
	return vec3(p.z*s+p.x*c,p.y,p.z*c-p.x*s);
}

vec3 rotZ(vec3 p,float a){
	float s=sin(radians(a)), c=cos(radians(a)); 
	return vec3(p.x*c-s*p.y,p.x*s+c*p.y,p.z);
}

float sphere( vec3 p, float r ) {
	return length(p) - r;
}

float ballon( vec3 p, float r){
	
	//float xdim = abs(0.01 * sin (p.y));
	
	//float  xdim = abs(p.y);
	float d = length(p) - r;
	float dis = p.y;
	//return d;
	return d -cos(0.5 * p.y + 0.2) * p.y;
	//p.y = clamp(p.y, -1.0 * r, 1.0 * r);
	//float dis = length(p.xz);
//	return dis -  abs(cos(p.y));
	
}
float cube( vec3 p, vec3 s ) {
	return length(max( abs(p) - s, 0.0) );
}

float fakeEllipsoid( vec3 p, vec3 s ) {
	vec3 lp = p / s;
	vec3 ep = normalize(lp) * s;
	return length(p - ep) * sign(length(lp) - 1.0);
}

float torus( vec3 p, vec3 rra ) {
	float sita = atan(p.y, p.x);
	vec3 q;
	
	if( abs(sita) < rra.z ) {
		q = vec3( length(p.xy) - rra.x, p.z, 0.0 );
	} else {
		p.y = abs(p.y);
		q = p - vec3( cos(rra.z), sin(rra.z), 0.0 ) * rra.x;
	}
	return length(q) - rra.y;
}

float cylinder( vec3 p, vec2 rh ) {
	vec2 cp = vec2( length(p.xz), p.y );
	return length( max(abs(cp) - rh, 0.0) );
}
vec3 textureSphere (vec3 p, float r)
{
	/*vec3 color = p + vec3(r, r, r);
	color = color / 0.25 / r;
	color = mod(color, 1.0);
	return color;*/
        float PI = 3.1415926;
	vec2 uv;
	vec3 n = normalize(p);
	
	vec3 up = vec3(0.0,1.0,0.0);
	vec3 forward = vec3(0.0, 0.0, 1.0);
	
	float phi = max(acos(dot(up,n)), 0.0);
	uv.y = phi / 3.1415926;
	
	uv.y = uv.y * 10.0;
	
	
	float tmp = dot(n,forward)/ sin(phi);
	tmp =  tmp > 1.0 ? 1.0 : tmp;
	tmp = tmp < -1.0 ? -1.0 : tmp;
	
	float theta = acos(tmp)/ (2.0 * PI );
	theta = theta > 1.0 ? 1.0 : theta;
	if(dot (cross(up, forward), n) > 0.0)
		uv.x = theta;
	else
		uv.x = 1.0 - theta;
	
	uv.x *= 20.0;
	
	
	
	vec3 color = vec3(sin(mod(uv.x, 1.0)), 0.2, 0.5);
	return color;
	
}
float rand3(vec3 n){ 
  return fract(sin(dot(n.xyz ,vec3(12.9898,78.233,4.1414))) * 43758.5453);
}

float scene( vec3 p, out vec4 color ) {
	
	
	//repetion
	//vec3 c = vec3(2,2,2);
	//p.x = mod(p.x, c.x);
	//p.y = mod(p.y, c.y);
	//p.z = mod(p.z, c.z);
	
	
	//p =  mod(p,c) - 0.5 * c;
	
	
	float anim = clamp( pow( sin(time * 3.14159 / 3.0), 3.0 ) * 1.2, -1.0, 1.0 );
//	p.x = time * p.x;
	//p.y = sin
	
	//p.x = sin(time* 3.14159 / 3.0);
	//p.y =  cos(time * 3.14159 / 3.0);
	
	const float melt = 0.008;
	const float meltmax = 0.0001;
	
	vec2 mousepos = (mouse - vec2(0.5)) * 2.0;
	
	//transforms
	p = rotX( p, mousepos.y * 60.0 );
	p = rotY( p,  mousepos.x * -180.0 );
	p -= vec3(0.0, -0.1, 0.0);
	
	vec3 mrrp = vec3( abs(p.x), p.y, p.z );
	
	float d0 = 0.0;
	//bottom
	d0 += max(meltmax, cube( p - vec3(0.0, -0.5, 0.0), vec3(0.1, 0.1, 0.1) ) - 0.04);
	
	//bottom inside
	float d1 = 0.0;
	d1 += max(meltmax,sphere(p - vec3(0.0, -0.4, 0.0),  0.1));
	//d1 += max(meltmax, ballon(p - vec3(0.0, 0.5, 0.0), 0.1));

	
	//ballon 
	float d2 = 0.0;
	d2 += max(meltmax,ballon(p - vec3(0.0, 0.5, 0.0),  0.5));
        float d = max( d1,  d0);
	
	if(d2 < d)
		color = vec4(textureSphere(p - vec3(0.0, 0.5, 0.0),  0.5), 0.4);
		//color = vec4(0.9,1.0,0.9,0.4);
	else
	        color = vec4(0.9,0.0,0.9,0.4);
		
		
	d = min(d2, d)
;	
	
	
	
	// 
	
	return d;
}

vec3 sceneNormal( vec3 p ) {
	const vec3 eps = vec3(0.001, 0.0, 0.0);
	vec3 norm;
	vec4 c;
	norm.x = scene( p + eps.xyz, c ) - scene( p - eps.xyz, c );
	norm.y = scene( p + eps.zxy, c ) - scene( p - eps.zxy, c );
	norm.z = scene( p + eps.yzx, c ) - scene( p - eps.yzx, c );
	return normalize(norm);
}

float ambientOcculution( vec3 p, vec3 n ) {
    const int steps = 3;
    const float delta = 0.2;

	vec4 c;
    float a = 0.0;
    float weight = 2.0;
    for( int i = 1; i <= steps; i++ ) {
        float d = (float(i) / float(steps)) * delta; 
        a += weight*(d - scene(p + n*d, c));
        weight *= 0.5;
    }
    return clamp(1.0 - a, 0.0, 1.0);
}

vec3 shading( vec3 pos, vec3 eyev, vec3 norm, vec4 col ) {
	const vec3 litpos = vec3(8.0, 10.0, 20.0);
	
	vec3 lv = normalize(litpos - pos);
	vec3 hv = normalize(eyev + lv);
	
	float nl = max(dot(norm, lv), 0.0);
	float nv = max(dot(norm, eyev), 0.0);
	float minnaert = 1.0 - max(-col.a, 0.0);
	
	float diffuse = pow(nl, minnaert) * pow(1.0 - nv, 1.0 - minnaert) + 0.2;
	float specular = pow(max(dot(norm, hv), 0.0), 160.0) *col.a;
	
	//float ao = ambientOcculution( pos, norm );
	float ao = 1.0;
	//return vec3(ao);
	return col.rgb * diffuse * ao + specular;
}

void main(void) {
	vec3 rgb;
	vec2 screen = (gl_FragCoord.xy - resolution * 0.5) / resolution.yy * 2.0;
	
	vec3 raydir = normalize( vec3( screen, -4.0 ) );
	vec3 raypos = vec3( 0.0, 0.0, 7.0 );
	vec4 color;
	float d;
	bool ishit = false;
	
	for( int i = 0; i < 64; i++ ) {
		d = scene(raypos, color);
		if( d < 0.02 ) {
			ishit = true;
			break;
		}
		raypos += 0.5*raydir * d;
	}
	
	if( ishit ) {
		vec3 n = sceneNormal( raypos );
		rgb = shading( raypos, -raydir, n, color );
	}
	else {
		rgb = mix( vec3(0.7, 1.0, 0.5), vec3(0.5, 0.7, 1.0), gl_FragCoord.y / resolution.y );
	}
	
	gl_FragColor = vec4( rgb, 1.0 );
}