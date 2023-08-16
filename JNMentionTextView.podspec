Pod::Spec.new do |s|
    
    s.name             = "JNMentionTextView"
    s.version          = "1.0.2"
    s.summary          = "JNMentionTextView is a UITextView replacement supporting the mention feature for iOS applications."
    s.description      = "A UITextView drop-in replacement supporting special characters such as [ #, @ ] and regex patterns, written in Swift."
    s.homepage                  = "https://github.com/JNDisrupter"
    s.license                   = { :type => 'MIT', :file => 'LICENSE' }
    s.authors                   = { "Jayel Zaghmoutt" => "eng.jayel.z@gmail.com", "Mohammad Nabulsi" => "mohammad.s.nabulsi@gmail.com", "Mohammad Ihmouda" => "mkihmouda@gmail.com" }
    
    s.platform                  = :ios
    s.platform                  = :ios, "11.0"
    s.swift_versions            = ['5.8', '5.8.1']
    s.source                    = { :git => "https://github.com/JNDisrupter/JNMentionTextView.git", :tag => "#{s.version}" }
    s.source_files              = "JNMentionTextView/**/*.{swift}"
end
