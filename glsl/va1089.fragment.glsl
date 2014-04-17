#ifdef GL_ES
precision mediump float;
#endif

// James Acres - Attempt at raymarching
// Faked shading based on ray length
//
// based on distance functions found at the always excellent:
// http://iquilezles.org/www/articles/distfunctions/distfunctions.htm
//
// and info from this thread:
// http://www.pouet.net/topic.php?which=7931&page=1&x=17&y=9

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.14159265358979323846264;

float sdTorus( vec3 p, vec2 t )
{
  vec2 q = vec2(length(p.xz)-t.x,p.y);
  return length(q)-t.y;
}

void rX(inout vec3 p, float a) {
    float c,s;vec3 q=p;
    c = cos(a); s = sin(a);
    p.y = c * q.y - s * q.z;
    p.z = s * q.y + c * q.z;
}

void rY(inout vec3 p, float a) {
    float c,s;vec3 q=p;
    c = cos(a); s = sin(a);
    p.x = c * q.x + s * q.z;
    p.z = -s * q.x + c * q.z;
}

void rZ(inout vec3 p, float a) {
    float c,s;vec3 q=p;
    c = cos(a); s = sin(a);
    p.x = c * q.x - s * q.y;
    p.y = s * q.x + c * q.y;
}


float distance(float x, float y, float z, float angle)
{
    vec3 torusPos = vec3( 0.0, 0.0, -0.75 );
    vec3 p = vec3(torusPos.x - x, torusPos.y - y, torusPos.z - z);

    rY(p, time);
    rX(p, PI/3.0);


    float c = cos(angle*p.y);
    float s = sin(angle*p.y);
    mat2  m = mat2(c,-s,s,c);
    vec3  q = vec3(m*p.xz,p.y);

    float d = sdTorus(q, vec2(0.7, 0.05));

	return d;
}

void main()
{
    bool didHit = false;

    // normalize fragCoord 0..1
    vec2 vUV = ( gl_FragCoord.xy / resolution.xy );
    // change range to -1.0 + 1.0
	vec2 vViewCoord = vUV * 2.0 - 1.0;

    // aspect ratio
    float fRatio = resolution.x / resolution.y;

    // correct for aspect ratio
    vViewCoord.y /= fRatio;

    vec3 ray_dir = normalize( vec3( vViewCoord, -1.0 ) );
    vec3 camera_pos = vec3( 0.0, 0.0, 1.0 );

    camera_pos += sin(time/10.0)/7.0;

    float d = 0.0;
    vec3 p = camera_pos + ray_dir * d;

    for ( float i=0.0; i<40.0; i+=1.0 ) {
	d = distance( p.x, p.y, p.z, mouse.x * 7.0 );

	if(d<0.3) {
	    didHit = true;
	    break;
	}

	p += 0.15*ray_dir*d;
    }

    if( didHit )
    {
	float lenP = 1.0-length(p);
	vec3 col = (vec3(1.0-length(p)*2.0));
	gl_FragColor = vec4(col.r, 0.0, col.r/2.0, 1.0) + vec4( 0.1, 0.0, 0.2, 1.0) + vec4(pow(lenP, 3.0));
    }
    else
    {
	gl_FragColor = vec4(1.0);
    }
}