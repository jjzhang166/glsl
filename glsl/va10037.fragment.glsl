#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;

vec2 get_pos() {
    vec2 pos = ( gl_FragCoord.xy / resolution.xy ) - vec2(1.0) * 0.5;
    pos.x *= resolution.x / resolution.y;
    return pos;
}

float get_distance_to_line(vec2 pos, vec2 point, float angle) {
    angle = angle/180.0*3.1415;
    vec2 another_point = point + vec2(cos(angle),sin(angle));
    vec2 line_dir = another_point - point;
    vec2 perp_dir = vec2(line_dir.y, -line_dir.x);
    vec2 dir_to_point = point - pos;
    return (dot(normalize(perp_dir), dir_to_point));
}

float get_radial_distance(vec2 pos, vec2 center) {
    vec2 tmp = pos-center;
    return sqrt(dot(tmp,tmp));
}

void main( void ) {
    vec2 pos = get_pos();
    float dist_to_center = length(pos);
    float dist_to_eye = get_radial_distance(pos,vec2(-0.06,0.2));
    float dist_to_ball1 = get_radial_distance(pos,vec2(0.3,0));
    float dist_to_ball2 = get_radial_distance(pos,vec2(0.6,0));
    float dist_to_line1 = get_distance_to_line(pos,vec2(0,0),40.0);
    float dist_to_line2 = get_distance_to_line(pos,vec2(0,0),-40.0);
    
    gl_FragColor = vec4(1.0,1.0,1.0,1.0);    
    if (dist_to_center < 0.4)
        gl_FragColor = mix(vec4(1.0,1.0,0.0,1.0),vec4(0.0,0.0,0.0,1.0),sqrt(dot(pos+vec2(-0.3),pos+vec2(-0.3))));
    else if (dist_to_center < 0.41)
        gl_FragColor = vec4(0,0.0,0.0,1.0);
    

    if (dist_to_line1 < 0.0 && dist_to_line2 > 0.0) 
        gl_FragColor = vec4(1.0,1.1,1.0,1.0);
    else if (dist_to_line1 < 0.01 && pos.x > -0.02 && pos.y > 0.0 && dist_to_center < 0.41)
        gl_FragColor = vec4(0.0,0.0,0.0,1.0);
    else if (dist_to_line2 > -0.01 && pos.x > -0.02 && pos.y < 0.001 && dist_to_center < 0.41)
        gl_FragColor = vec4(0.0,0.0,0.0,1.0);


    if (dist_to_eye < 0.05) 
	gl_FragColor = vec4(0.0,0.0,0.0,1.0);


    if (dist_to_ball1 < 0.08 || dist_to_ball2 < 0.08) 
	gl_FragColor = mix(vec4(1.0,1.0,0.0,1.0),vec4(0.0,0.0,0.0,1.0),sqrt(dot(pos+vec2(-0.3),pos+vec2(-0.3))));
}