class Status < ClassyEnum::Base
end

class Status::Passed < Status
end

class Status::Rejected < Status
end

class Status::Processing < Status
end
