
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float map(vec3 p)
{
    const int MAX_ITER = 10;
    const float BAILOUT=6.9;
    float Power=6.0;

    vec3 v = p;
    vec3 c = v;

    float r=0.0;
    float d=1.0;
    for(int n=0; n<=MAX_ITER; ++n)
    {
        r = length(v);
        if(r>BAILOUT) break;

        float theta = acos(v.z/r);
        float phi = atan(v.y, v.x);
        d = pow(r,Power-1.0)*Power*d+1.0;

        float zr = pow(r,Power);
        theta = theta*Power;
        phi = phi*Power;
        v = (vec3(sin(theta)*cos(phi), sin(phi)*sin(theta), cos(theta))*zr)+c;
    }
    return 0.5*log(r)*r/d;
}


void main( void )
{
    const int numlights = 5;
    vec3 lightsposition[5];
    lightsposition[0] = vec3( 2.0,-2.0,-2.0);
    lightsposition[1] = vec3( 2.0,-2.0, 2.0);
    lightsposition[2] = vec3(-2.0,-2.0, 2.0);
    lightsposition[3] = vec3(-2.0,-2.0,-2.0);
    lightsposition[4] = vec3( 2.0, 2.0,-2.0);
    vec3 lightsdiffuse[5];
    lightsdiffuse[0] = vec3(1.0,1.0,1.0);
    lightsdiffuse[1] = vec3(1.0,1.0,0.4);
    lightsdiffuse[2] = vec3(0.8,0.98,0.2);
    lightsdiffuse[3] = vec3(0.7,0.0,0.8);
    lightsdiffuse[4] = vec3(0.1,0.0,0.3);
    const vec3 materialdiffuse = vec3(0.8, 1.0, 1.0);
    const float materialspecularexponent = 300.0;
	
    vec2 pos = (gl_FragCoord.xy*2.0 - resolution.xy) / resolution.y;
    vec3 camPos = vec3(2.*sin(time), sin(time), 2.*cos(time));
    vec3 camTarget = vec3(0.0, 0.0, 0.0);

    vec3 camDir = normalize(camTarget-camPos);
    vec3 camUp  = normalize(vec3(0.0, 1.0, 0.0));
    vec3 camSide = cross(camDir, camUp);
    float focus = 2.2;

    vec3 rayDir = normalize(camSide*pos.x + camUp*pos.y + camDir*focus);
    vec3 ray = camPos;
    float m = 0.0;
    float d = 0.0, total_d = 0.0;
    const int MAX_MARCH = 50;
    const float MAX_DISTANCE = 1.0;
    for(int i=0; i<MAX_MARCH; ++i) {
        d = map(ray);
        total_d += d;
        ray += rayDir * d;
        m += 1.0;
        if(d<0.001) { break; }
        if(total_d>MAX_DISTANCE) { total_d=MAX_DISTANCE; break; }
    }
    //with some shading code from https://code.google.com/p/creativecomputing/source/browse/cc.creativecomputing/data/demo/gpu/raymarching/mandelbulb.glsl?r=7eba02ca94b3a19bb0d1fd5cd80960858869afb8
    vec3 normal;
    const float epsilon = 0.01;
    normal.x = map(ray+vec3(epsilon,0.0,0.0));
    normal.y = map(ray+vec3(0.0,epsilon,0.0));
    normal.z = map(ray+vec3(0.0,0.0,epsilon));
    normal -= map(ray);
    normal = normalize(normal);
    //phong shading calculations for surface hitpoint
    vec3 color = vec3(0, 0, 0);
    vec3 camera_direction = normalize(camPos-ray);
    for (int i=0; i < numlights; i++) {
        vec3 light_dir = normalize(lightsposition[i]-ray);
        float diffuse = max(dot(light_dir, normal),0.0);
        float specular = max(dot(reflect(-light_dir, normal), camera_direction),0.0);
        color += (lightsdiffuse[i]*diffuse).xyz*materialdiffuse.xyz;
        //implicit white specular
         color += pow(specular, materialspecularexponent);
    }
    gl_FragColor = vec4(color, 1.0);	
	
    //float c = (total_d)*0.0001;
    //vec4 result = vec4( 1.0-vec3(c, c, c) - vec3(0.025, 0.025, 0.02)*m*0.8, 1.0 );
    //gl_FragColor = result;
}
